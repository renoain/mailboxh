import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const MovieDetailPage({super.key, required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      body: DefaultTabController(
        length: 5, // Sekarang ada 5 Tab (Cast, Crew, Details, Genre, Releases)
        child: CustomScrollView(
          slivers: [
            // 1. BACKDROP & APP BAR
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF14181C),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(movieData['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(movieData['image'], fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xFF14181C)], stops: [0.4, 1.0]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. KONTEN UTAMA
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul & Poster Kecil
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movieData['title'], style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('${movieData['year']} • DIRECTED BY', style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1)),
                              const SizedBox(height: 4),
                              Text(movieData['director'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: const Color(0xFF445566), borderRadius: BorderRadius.circular(20)),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.play_arrow, color: Colors.white, size: 18),
                                        SizedBox(width: 4),
                                        Text('TRAILER', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(movieData['duration'], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 90, height: 135,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(image: NetworkImage(movieData['image']), fit: BoxFit.cover),
                            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sinopsis
                    Text(movieData['tagline'], style: const TextStyle(color: Color(0xFFB0C0D0), fontSize: 14, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Text(movieData['synopsis'], style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFF2C3440)),
                    
                    // Grafik Rating
                    const SizedBox(height: 12),
                    const Text('RATINGS', style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF00E054), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [_buildBar(10), _buildBar(20), _buildBar(30), _buildBar(50), _buildBar(60), _buildBar(45), _buildBar(35), _buildBar(20)],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('3.9', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        ...List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFF00E054), size: 14)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF2C3440)),

                    // Where to watch
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Where to watch', style: TextStyle(color: Colors.white, fontSize: 18)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {},
                    ),
                    const Divider(color: Color(0xFF2C3440)),
                    const SizedBox(height: 16),

                    // 3 Kotak Warna
                    Row(
                      children: [
                        _buildBoxButton('Members', '561k', const Color(0xFF00E054), Icons.remove_red_eye),
                        _buildBoxButton('Reviews', '266k', const Color(0xFF8A9BAE), Icons.article),
                        _buildBoxButton('Lists', '138k', const Color(0xFF40BCF4), Icons.video_library),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Related News
                    const Text('RELATED NEWS (1 OF 3)', style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Container(
                            width: 140,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                              image: DecorationImage(image: NetworkImage('https://picsum.photos/seed/news/300/300'), fit: BoxFit.cover),
                            ),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Show Me the Movies', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Tom Cruise on the origins, influences and comedy of this film.', style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.3)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 3. TAB BAR (Cast, Crew, Details, Genre, Releases)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  isScrollable: true,
                  indicatorColor: Color(0xFF00E054),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  tabs: [
                    Tab(text: 'Cast'),
                    Tab(text: 'Crew'),
                    Tab(text: 'Details'),
                    Tab(text: 'Genre'),
                    Tab(text: 'Releases'),
                  ],
                ),
              ),
            ),

            // 4. ISI TAB (Sekarang semua terisi!)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    // --- TAB CAST ---
                    ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _buildListItem('Tom Cruise', 'Rockwell', 'https://picsum.photos/seed/tom/100/100', Icons.person),
                        _buildListItem('Riz Ahmed', 'Ganesh', 'https://picsum.photos/seed/riz/100/100', Icons.person),
                        _buildListItem('John Goodman', 'President Compson', 'https://picsum.photos/seed/john/100/100', Icons.person),
                        _buildListItem('Sandra Hüller', 'Anna', 'https://picsum.photos/seed/sandra/100/100', Icons.person),
                        _buildListItem('Jesse Plemons', 'Agent', 'https://picsum.photos/seed/jesse/100/100', Icons.person),
                      ],
                    ),
                    
                    // --- TAB CREW ---
                    ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _buildListItem('Alejandro G. Iñárritu', 'Director', '', Icons.movie_creation),
                        _buildListItem('Jack Fisk', 'Production Design', '', Icons.design_services),
                        _buildListItem('Sabrina Morris', 'Costume Design', '', Icons.checkroom),
                        _buildListItem('Ludwig Göransson', 'Original Music', '', Icons.music_note),
                        _buildListItem('Matthew Libatique', 'Cinematography', '', Icons.camera),
                      ],
                    ),

                    // --- TAB DETAILS ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Director', movieData['director']),
                          _buildDetailRow('Genre', movieData['genre']),
                          _buildDetailRow('Release Date', 'October 18, ${movieData['year']}'),
                          _buildDetailRow('Runtime', movieData['duration']),
                          _buildDetailRow('Studio', 'Warner Bros. Pictures'),
                          _buildDetailRow('Language', 'English, Spanish'),
                        ],
                      ),
                    ),

                    // --- TAB GENRE ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildGenreChip('Drama'),
                          _buildGenreChip('Comedy'),
                          _buildGenreChip('Action'),
                          _buildGenreChip('Thriller'),
                          _buildGenreChip('Sci-Fi'),
                        ],
                      ),
                    ),

                    // --- TAB RELEASES ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('United States', 'October 18, ${movieData['year']}'),
                          _buildDetailRow('United Kingdom', 'October 20, ${movieData['year']}'),
                          _buildDetailRow('Indonesia', 'October 22, ${movieData['year']}'),
                          _buildDetailRow('Japan', 'November 05, ${movieData['year']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN ---
  Widget _buildBar(double height) {
    return Container(width: 14, height: height, decoration: BoxDecoration(color: const Color(0xFF445566), borderRadius: BorderRadius.circular(2)));
  }

  Widget _buildBoxButton(String title, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        height: 90,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget List Umum untuk Cast / Crew
  Widget _buildListItem(String name, String role, String imageUrl, IconData fallbackIcon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF2C3440),
          borderRadius: BorderRadius.circular(4),
          image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
        ),
        child: imageUrl.isEmpty ? Icon(fallbackIcon, color: Colors.grey) : null,
      ),
      title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 18)),
      subtitle: Text(role, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  // Widget Baris Detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  // Widget Chip Genre
  Widget _buildGenreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3440),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xFF14181C), child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}