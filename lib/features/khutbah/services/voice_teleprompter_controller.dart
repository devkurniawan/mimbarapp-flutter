import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Callback ketika hasil transkrip suara diterima (baik partial maupun final).
typedef OnSpeechTranscriptCallback = void Function(
  String transcript,
  bool isFinal,
  double confidence,
);

/// Callback perubahan level amplitudo suara mikrofon (0.0 s/d 1.0).
typedef OnSoundLevelCallback = void Function(double normalizedLevel);

/// Controller modular untuk mengelola Speech-to-Text Bahasa Indonesia (`id_ID`)
/// dengan fitur Continuous Auto-Restart Listener dan dukungan Offline On-Device (PRD 5.2).
class VoiceTeleprompterController {
  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;
  bool _isVoiceSyncActive = false;
  bool _preferOfflineMode = false;
  bool _isRestarting = false;
  String _selectedLocaleId = 'id_ID';
  String _lastRecognizedWords = '';
  Timer? _restartWatchdogTimer;

  final OnSpeechTranscriptCallback onTranscript;
  final OnSoundLevelCallback? onSoundLevel;
  final ValueChanged<String>? onStatusMessage;
  final ValueChanged<bool>? onListeningStateChanged;

  VoiceTeleprompterController({
    required this.onTranscript,
    this.onSoundLevel,
    this.onStatusMessage,
    this.onListeningStateChanged,
  });

  bool get isInitialized => _isInitialized;
  bool get isVoiceSyncActive => _isVoiceSyncActive;
  bool get isListening => _speech.isListening;
  bool get preferOfflineMode => _preferOfflineMode;
  String get selectedLocaleId => _selectedLocaleId;
  String get lastRecognizedWords => _lastRecognizedWords;

  /// Menginisialisasi engine Speech-to-Text dan memilih locale Bahasa Indonesia terbaik.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Minta izin mikrofon terlebih dahulu
      final status = await Permission.microphone.request();
      if (!status.isGranted && !status.isLimited) {
        onStatusMessage?.call('Izin mikrofon diperlukan untuk fitur Voice Sync');
        return false;
      }

      _isInitialized = await _speech.initialize(
        onStatus: _handleSpeechStatus,
        onError: _handleSpeechError,
        debugLogging: false,
      );

      if (_isInitialized) {
        final locales = await _speech.locales();
        // Cari Bahasa Indonesia (id_ID atau id-ID atau in_ID)
        final indoLocale = locales.where((l) {
          final id = l.localeId.toLowerCase();
          return id.startsWith('id') || id.startsWith('in');
        }).toList();

        if (indoLocale.isNotEmpty) {
          _selectedLocaleId = indoLocale.first.localeId;
        } else {
          final systemLocale = await _speech.systemLocale();
          _selectedLocaleId = systemLocale?.localeId ?? 'id_ID';
        }
      } else {
        onStatusMessage?.call(
          'Layanan pengenalan suara tidak tersedia di perangkat ini',
        );
      }

      return _isInitialized;
    } catch (e) {
      onStatusMessage?.call('Mode Simulasi / Desktop (STT OS tidak didukung)');
      return false;
    }
  }

  void setPreferOfflineMode(bool offline) {
    _preferOfflineMode = offline;
    if (_isVoiceSyncActive) {
      _restartListeningSession();
    }
  }

  /// Memulai sesi Voice Sync secara kontinu (otomatis menyambung saat jeda napas khatib).
  Future<bool> startVoiceSync() async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return false;
    }

    _isVoiceSyncActive = true;
    onListeningStateChanged?.call(true);
    await _startListeningInternal();
    _startWatchdog();
    return true;
  }

  /// Menghentikan sesi Voice Sync sepenuhnya.
  Future<void> stopVoiceSync() async {
    _isVoiceSyncActive = false;
    _restartWatchdogTimer?.cancel();
    _restartWatchdogTimer = null;
    onListeningStateChanged?.call(false);

    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (_) {}
  }

  Future<void> _startListeningInternal() async {
    if (!_isVoiceSyncActive || !_isInitialized || _isRestarting) return;
    if (_speech.isListening) return;

    _isRestarting = true;
    try {
      await _speech.listen(
        onResult: _handleSpeechResult,
        onSoundLevelChange: (level) {
          // Normalisasi dB (-2 s/d 10) ke rentang 0.0 - 1.0
          final normalized = ((level + 2.0) / 12.0).clamp(0.05, 1.0);
          onSoundLevel?.call(normalized);
        },
        listenOptions: SpeechListenOptions(
          localeId: _selectedLocaleId,
          listenFor: const Duration(minutes: 10),
          pauseFor: const Duration(seconds: 8),
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.dictation,
          onDevice: _preferOfflineMode,
        ),
      );
    } catch (_) {
      // Fallback jika onDevice gagal karena bahasa offline belum diunduh di HP
      if (_preferOfflineMode) {
        _preferOfflineMode = false;
        onStatusMessage?.call(
          'Paket bahasa offline belum ada di HP, beralih ke mode standar',
        );
        try {
          await _speech.listen(
            onResult: _handleSpeechResult,
            listenOptions: SpeechListenOptions(
              localeId: _selectedLocaleId,
              listenFor: const Duration(minutes: 10),
              pauseFor: const Duration(seconds: 8),
              partialResults: true,
              cancelOnError: false,
              listenMode: ListenMode.dictation,
              onDevice: false,
            ),
          );
        } catch (_) {}
      }
    } finally {
      _isRestarting = false;
    }
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    final words = result.recognizedWords.trim();
    if (words.isEmpty) return;

    _lastRecognizedWords = words;
    onTranscript(
      words,
      result.finalResult,
      result.hasConfidenceRating ? result.confidence : 0.85,
    );
  }

  void _handleSpeechStatus(String status) {
    if (!_isVoiceSyncActive) return;

    // Jika OS menghentikan sesi karena jeda hening (done / notListening), langsung nyalakan kembali
    if (status == 'done' || status == 'notListening') {
      _restartListeningSession();
    }
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    if (!_isVoiceSyncActive) return;

    // Abaikan error timeout hening ("error_speech_timeout" / "error_no_match") saat khatib jeda napas
    _restartListeningSession();
  }

  void _restartListeningSession() {
    if (!_isVoiceSyncActive || _isRestarting) return;
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_isVoiceSyncActive && !_speech.isListening) {
        _startListeningInternal();
      }
    });
  }

  void _startWatchdog() {
    _restartWatchdogTimer?.cancel();
    _restartWatchdogTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_isVoiceSyncActive && !_speech.isListening && !_isRestarting) {
        _startListeningInternal();
      }
    });
  }

  void dispose() {
    _isVoiceSyncActive = false;
    _restartWatchdogTimer?.cancel();
    try {
      _speech.cancel();
    } catch (_) {}
  }
}

