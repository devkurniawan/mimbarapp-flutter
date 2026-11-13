import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class MosqueScreen extends StatelessWidget {
  const MosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildTopSection(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Nearby Mosque'),
                  const SizedBox(height: 16),
                  _buildMosqueList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryMid,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // Mock Map Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                'https://api.mapbox.com/styles/v1/mapbox/dark-v10/static/-6.2088,106.8456,12/600x400?access_token=placeholder', // Placeholder URL
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.blueGrey[900]),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Mosque',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'There are 15 mosques near you',
                          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Floating marker mockup
          const Center(
            child: Icon(LucideIcons.mapPin, color: AppColors.accentGreen, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(LucideIcons.search, color: Colors.grey),
          hintText: 'Search by mosque name...',
          hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMid,
          ),
        ),
        const Icon(LucideIcons.filter, color: AppColors.accentGreen, size: 20),
      ],
    );
  }

  Widget _buildMosqueList() {
    return Column(
      children: [
        _buildMosqueCard(
          name: 'Istiqlal Mosque',
          address: 'Jl. Taman Wijaya Kusuma, Jakarta',
          distance: '1.2 km',
          facilities: [LucideIcons.wind, LucideIcons.car, LucideIcons.accessibility],
          imageUrl: 'https://images.unsplash.com/photo-1590076212ef5-da0be7911631?q=80&w=400&auto=format&fit=crop',
        ),
        const SizedBox(height: 16),
        _buildMosqueCard(
          name: 'Al-Azhar Great Mosque',
          address: 'Jl. Sisingamangaraja, Jakarta',
          distance: '3.5 km',
          facilities: [LucideIcons.wind, LucideIcons.car],
          imageUrl: 'https://images.unsplash.com/photo-1542640244-7e672d6cef21?q=80&w=400&auto=format&fit=crop',
        ),
        const SizedBox(height: 16),
        _buildMosqueCard(
          name: 'Sunda Kelapa Mosque',
          address: 'Jl. Taman Sunda Kelapa, Jakarta',
          distance: '4.1 km',
          facilities: [LucideIcons.wind, LucideIcons.car, LucideIcons.coffee],
          imageUrl: 'https://images.unsplash.com/photo-1564769662533-4f00a87b4056?q=80&w=400&auto=format&fit=crop',
        ),
      ],
    );
  }

  Widget _buildMosqueCard({
    required String name,
    required String address,
    required String distance,
    required List<IconData> facilities,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], height: 140),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    distance,
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...facilities.map((icon) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(icon, size: 16, color: AppColors.primaryMid.withValues(alpha: 0.6)),
                    )),
                    const Spacer(),
                    Text(
                      'Open Now',
                      style: GoogleFonts.outfit(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
