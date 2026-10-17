import 'package:flutter/material.dart';
import '../../detail/presentation/movie_detail_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Daftar Film tiruan dengan data lengkap
  final List<Map<String, dynamic>> movies = const [
    {
      'title': 'Digger',
      'image': 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg',
      'year': '2026',
      'director': 'Alejandro G. Iñárritu',
      'genre': 'Drama, Comedy',
      'duration': '129 mins',
      'tagline': 'A MAN. A PLAN. A MELTDOWN.',
      'synopsis': 'The most powerful man in the world embarks on a frantic mission to prove he is humanity\'s savior before the disaster he\'s unleashed destroys everything.',
    },
    {
      'title': 'Resident Evil',
      'image': 'https://image.tmdb.org/t/p/w500/7QCbZcn2t25H8DkYq7eF4vO8uJk.jpg',
      'year': '2024',
      'director': 'Zach Cregger',
      'genre': 'Horror, Action',
      'duration': '110 mins',
      'tagline': 'EVIL HAS A NEW HOME.',
      'synopsis': 'A group of survivors must fight for their lives in a post-apocalyptic world overrun by zombies and monstrous creatures.',
    },
    {
      'title': 'Spider-Man: Brand New Day',
      'image': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg',
      'year': '2026',
      'director': 'Destin Daniel Cretton',
      'genre': 'Action, Adventure',
      'duration': '140 mins',
      'tagline': 'A NEW BEGINNING.',
      'synopsis': 'Peter Parker faces new challenges as he navigates life as a young adult, while a mysterious new threat emerges in New York City.',
    },
    {
      'title': 'Carrie',
      'image': 'https://image.tmdb.org/t/p/w500/7l4eB5e1B5e1B5e1B5e1B5e1B5e1.jpg',
      'year': '2013',
      'director': 'Kimberly Peirce',
      'genre': 'Horror, Drama',
      'duration': '100 mins',
      'tagline': 'TAKE HER TO THE PROM.',
      'synopsis': 'A shy and bullied teenage girl discovers she has telekinetic powers and uses them to exact revenge on her tormentors at prom.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF14181C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF14181C),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false, 
          title: const Text('Letterboxd', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          bottom: const TabBar(
            indicatorColor: Color(0xFF00E054),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Films'),
              Tab(text: 'Reviews'),
              Tab(text: 'Lists'),
              Tab(text: 'Journal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: FILMS
            GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2 / 3,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    // Kirim seluruh data film ke halaman detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movieData: movie),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(image: NetworkImage(movie['image']), fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),

            // TAB 2: REVIEWS
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: Color(0xFF00E054), radius: 14, child: Icon(Icons.person, size: 18, color: Colors.black)),
                          const SizedBox(width: 8),
                          Text('User ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          const Spacer(),
                          const Icon(Icons.star, color: Color(0xFF00E054), size: 14),
                          const Text(' 4.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Film ini sangat seru! Alur ceritanya tidak terduga dan akting para pemainnya luar biasa.', style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 14)),
                    ],
                  ),
                );
              },
            ),

            // TAB 3: LISTS
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Icon(Icons.format_list_bulleted, color: Color(0xFF00E054), size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Best Movies of 2024 - Part ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('by User Name', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // TAB 4: JOURNAL
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF2C3440), width: 1))),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('Oct', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          Text('1${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(width: 50, height: 75, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.movie, color: Colors.white54)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Journal Entry ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Color(0xFF00E054), size: 14),
                                Icon(Icons.star, color: Color(0xFF00E054), size: 14),
                                Icon(Icons.star, color: Color(0xFF00E054), size: 14),
                                Icon(Icons.star_border, color: Color(0xFF00E054), size: 14),
                                Icon(Icons.star_border, color: Color(0xFF00E054), size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}