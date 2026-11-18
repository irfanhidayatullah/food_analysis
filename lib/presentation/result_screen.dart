import 'dart:io';

import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final File imageFile;
  const ResultScreen({super.key, required this.data, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> nutrisi =
        (data["komposisi_nutrisi"] is Map<String, dynamic>)
        ? data["komposisi_nutrisi"]
        : data;

    final List nutritionItems = [
      {
        'title': 'Karbohidrat',
        'value': nutrisi['karbohidrat']?.toString() ?? '-',
        'icon': Icons.local_pizza_rounded,
        'bgColor': const Color(0xFFFDE0B6),
      },
      {
        'title': 'Protein',
        'value': nutrisi['protein']?.toString() ?? '-',
        'icon': Icons.egg_alt_rounded,
        'bgColor': const Color(0xFFC8E6C9),
      },
      {
        'title': 'Lemak',
        'value': nutrisi['lemak']?.toString() ?? '-',
        'icon': Icons.oil_barrel_rounded,
        'bgColor': const Color(0xFFF9C6CC),
      },
      {
        'title': 'Serat',
        'value': nutrisi['serat']?.toString() ?? '-',
        'icon': Icons.grass_rounded,
        'bgColor': const Color(0xFFBBDEFB),
      },
      {
        'title': 'Vitamin',
        'value': nutrisi['vitamin']?.toString() ?? '-',
        'icon': Icons.local_florist_rounded,
        'bgColor': const Color(0xFFD9BCE8),
      },
      {
        'title': 'Kolesterol',
        'value': nutrisi['kolesterol']?.toString() ?? '-',
        'icon': Icons.health_and_safety_rounded,
        'bgColor': const Color(0xFFF4A8B4),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hasil Analisis",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(imageFile.path),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.fastfood_rounded,
              title: "Nama Makanan",
              value: data['nama_makanan']?.toString() ?? "Tidak diketahui",
              backgroundColor: const Color(0xFFF5EBD6),
            ),
            const SizedBox(height: 14),

            _buildInfoCard(
              icon: Icons.verified_rounded,
              title: "Status Kehalalan",
              value: data['kehalalan']?.toString() ?? "Tidak diketahui",
              backgroundColor: const Color(0xFFE5F4E7),
            ),
            const SizedBox(height: 22),

            const Text(
              "Komposisi Nutrisi :",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nutritionItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final item = nutritionItems[index];
                return _buildNutritionCard(
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  value: item['value'] as String,
                  backgroundColor: item['bgColor'] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoCard({
  required IconData icon,
  required String title,
  required String value,
  required Color backgroundColor,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFE64A19), size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildNutritionCard({
  required IconData icon,
  required String title,
  required String value,
  required Color backgroundColor,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFE64A19), size: 28),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
