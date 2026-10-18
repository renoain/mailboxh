import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../detail/presentation/movie_detail_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const AppText text = AppStrings.id;

  final List<Map<String, dynamic>> movies = const [
    {
      'title': 'Digger', 'image': 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg', 'year': '2026',
      'director': 'Alejandro G. Iñárritu', 'genre': 'Drama, Comedy', 'duration': '129 mins',
      'tagline': 'A MAN. A PLAN. A MELTDOWN.', 'synopsis': 'The most powerful man in the world embarks on a frantic mission.',
    },
    {
      'title': 'Resident Evil', 'image': 'https://image.tmdb.org/t/p/w500/7QCbZcn2t25H8DkYq7eF4vO8uJk.jpg', 'year': '2024',
      'director': 'Zach Cregger', 'genre': 'Horror, Action', 'duration': '110 mins',
      'tagline': 'EVIL HAS A NEW HOME.', 'synopsis': 'A group of survivors must fight for their lives.',
    },
    {
      'title': 'Spider-Man', 'image': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', 'year': '2026',
      'director': 'Destin Daniel Cretton', 'genre': 'Action, Adventure', 'duration': '140 mins',
      'tagline': 'A NEW BEGINNING.', 'synopsis': 'Peter Parker faces new challenges.',
    },
    {
      'title': 'Carrie', 'image': 'https://image.tmdb.org/t/p/w500/7l4eB5e1B5e1B5e1B5e1B5e1B5e1.jpg', 'year': '2013',
      'director': 'Kimberly Peirce', 'genre': 'Horror, Drama', 'duration': '100 mins',
      'tagline': 'TAKE HER TO THE PROM.', 'synopsis': 'A shy and bullied teenage girl discovers she has telekinetic powers.',
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
          title: Text(text.appName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          bottom: const TabBar(
            indicatorColor: Color(0xFF00E054),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            tabs: [Tab(text: 'Films'), Tab(text: 'Reviews'), Tab(text: 'Lists'), Tab(text: 'Journal')],
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailPage(movieData: movie)));
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

            // TAB 3: LISTS (SUDAH BISA DIKLIK)
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Membuka halaman detail list saat diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _ListDetailPage(
                          listTitle: 'Best Movies of 2024 - Part ${index + 1}',
                          movies: movies, // Melempar data film ke halaman list
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
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

// =====================================================================
// HALAMAN BARU: Detail List (Menampilkan kumpulan film saat list diklik)
// =====================================================================
class _ListDetailPage extends StatelessWidget {
  final String listTitle;
  final List<Map<String, dynamic>> movies;

  const _ListDetailPage({required this.listTitle, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(listTitle, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Movies in this list', style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      // Poster Kecil
                      Container(
                        width: 60, height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(image: NetworkImage(movie['image']), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info Film
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${movie['year']} • ${movie['director']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      // Tombol panah untuk ke detail film
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailPage(movieData: movie)));
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}