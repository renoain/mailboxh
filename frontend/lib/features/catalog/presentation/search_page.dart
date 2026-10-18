import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../../core/providers/app_state.dart'; 
import '../../detail/presentation/movie_detail_page.dart'; 
import '../../auth/presentation/login_page.dart'; 

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = '';

  final List<Map<String, dynamic>> _allMovies = const [
    {
      'title': 'Digger', 'image': 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg', 'year': '2026',
      'director': 'Alejandro G. Iñárritu', 'genre': 'Drama', 'duration': '129 mins', 'rating': 4.5, 'popularity': 99,
      'cast': ['Tom Cruise', 'Riz Ahmed'], 'tagline': 'A MAN. A PLAN. A MELTDOWN.', 'synopsis': 'The most powerful man in the world embarks on a frantic mission.',
    },
    {
      'title': 'Resident Evil', 'image': 'https://image.tmdb.org/t/p/w500/7QCbZcn2t25H8DkYq7eF4vO8uJk.jpg', 'year': '2024',
      'director': 'Zach Cregger', 'genre': 'Horror', 'duration': '110 mins', 'rating': 4.0, 'popularity': 85,
      'cast': ['Milla Jovovich'], 'tagline': 'EVIL HAS A NEW HOME.', 'synopsis': 'A group of survivors must fight for their lives.',
    },
    {
      'title': 'Spider-Man', 'image': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', 'year': '2026',
      'director': 'Destin Daniel Cretton', 'genre': 'Action', 'duration': '140 mins', 'rating': 4.8, 'popularity': 100,
      'cast': ['Tom Holland', 'Zendaya'], 'tagline': 'A NEW BEGINNING.', 'synopsis': 'Peter Parker faces new challenges.',
    },
  ];

  List<Map<String, dynamic>> get _filteredMovies {
    List<Map<String, dynamic>> result = _allMovies;
    if (_searchQuery.isNotEmpty) {
      result = result.where((movie) {
        final titleMatch = movie['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
        final castMatch = (movie['cast'] as List).any((actor) => actor.toLowerCase().contains(_searchQuery.toLowerCase()));
        return titleMatch || castMatch;
      }).toList();
    }
    if (_activeFilter == 'Highest rated') {
      result = List.from(result)..sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (_activeFilter == 'Most popular') {
      result = List.from(result)..sort((a, b) => b['popularity'].compareTo(a['popularity']));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context); 
    bool isShowingResults = _searchQuery.isNotEmpty || _activeFilter.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() { _searchQuery = value; _activeFilter = ''; });
                },
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Search films, cast, members...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
                  suffixIcon: isShowingResults
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            setState(() { _searchQuery = ''; _activeFilter = ''; });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF4A5C6E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Expanded(
              child: isShowingResults ? _buildResults(appState) : _buildBrowseMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppState appState) {
    final movies = _filteredMovies;
    if (movies.isEmpty) {
      return const Center(child: Text('Tidak ada hasil ditemukan', style: TextStyle(color: Colors.grey, fontSize: 18)));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _activeFilter.isNotEmpty ? 'FILTER: ${_activeFilter.toUpperCase()}' : 'FILMS',
            style: const TextStyle(color: Color(0xFF00E054), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
        ...movies.map((movie) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50, height: 75,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(image: NetworkImage(movie['image']), fit: BoxFit.cover),
            ),
          ),
          title: Text(movie['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Text('${movie['year']} • ${movie['genre']}', style: const TextStyle(color: Colors.grey)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Color(0xFF00E054), size: 16),
              const SizedBox(width: 4),
              Text(movie['rating'].toString(), style: const TextStyle(color: Colors.white)),
            ],
          ),
          onTap: () {
            if (!appState.isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Silakan Sign In untuk melihat detail film.'), backgroundColor: Colors.redAccent),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailPage(movieData: movie)));
          },
        )),
      ],
    );
  }

  Widget _buildBrowseMenu() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Text('BROWSE BY', style: TextStyle(color: Color(0xFF6B7A8D), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildMenuRow('Release date', 'Release date'),
        _buildMenuRow('Genre, country or language', 'Genre'),
        _buildMenuRow('Service', 'Service'),
        _buildMenuRow('Most popular', 'Most popular'),
        _buildMenuRow('Highest rated', 'Highest rated'),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF2C3440)),
        const SizedBox(height: 16),
        const Text('LETTERBOXD.COM', style: TextStyle(color: Color(0xFF6B7A8D), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildMenuRow('New here?', 'New'),
      ],
    );
  }

  Widget _buildMenuRow(String title, String filterKey) {
    return InkWell(
      onTap: () {
        setState(() {
          _searchController.clear();
          _searchQuery = '';
          _activeFilter = filterKey;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const Icon(Icons.chevron_right, color: Color(0xFF6B7A8D)),
          ],
        ),
      ),
    );
  }
}