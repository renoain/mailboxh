import 'package:flutter/material.dart';
import '../../members/presentation/member_profile_page.dart'; 

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        elevation: 0,
        centerTitle: true,
        title: const Text('Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 6,
        itemBuilder: (context, index) {
          final users = ['Budi', 'Siti', 'Andi', 'Rina', 'Joko', 'Dewi'];
          final movies = ['Spider-Man', 'Digger', 'Resident Evil', 'Carrie', 'Social Network', 'Whalefall'];
          final actions = ['watched', 'reviewed', 'added to watchlist', 'rated', 'liked', 'watched'];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1B2228),
              border: Border(bottom: BorderSide(color: Color(0xFF2C3440), width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(memberName: users[index])));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF2C3440),
                    child: Text(users[index][0], style: const TextStyle(color: Color(0xFF00E054), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(memberName: users[index])));
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
                            children: [
                              TextSpan(text: users[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              TextSpan(text: ' ${actions[index]} '),
                              TextSpan(text: movies[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Kartu Film
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(2),
                                image: const DecorationImage(image: NetworkImage('https://picsum.photos/seed/feed/100/150'), fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(movies[index], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(starIndex < 3 ? Icons.star : Icons.star_border, color: const Color(0xFF00E054), size: 12);
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}