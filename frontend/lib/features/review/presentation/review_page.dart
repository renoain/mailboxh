import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        elevation: 0,
        title: const Text('Reviews', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3440),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF00E054),
                      radius: 16,
                      child: Icon(Icons.person, size: 20, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Text('User ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    const Icon(Icons.star, color: Color(0xFF00E054), size: 16),
                    const Text(' 4.0', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Film ini sangat seru! Alur ceritanya tidak terduga dan akting para pemainnya luar biasa. Sangat direkomendasikan untuk ditonton di akhir pekan.',
                  style: TextStyle(color: Color(0xFFB0C0D0), height: 1.5, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}