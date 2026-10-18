import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_state.dart';
import '../../auth/presentation/login_page.dart'; 

class MovieDetailPage extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const MovieDetailPage({super.key, required this.movieData});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  static const AppText text = AppStrings.id;

  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  final List<Map<String, dynamic>> _reviews = [
    {
      'user': 'Budi', 'rating': 5.0, 'text': 'Film yang luar biasa! Aktingnya sangat memukau dan alur ceritanya tidak terduga.', 'likes': 124, 'isLiked': false,
    },
    {
      'user': 'Siti', 'rating': 4.0, 'text': 'Sinematografinya keren banget, tapi bagian ending agak terlalu cepat.', 'likes': 89, 'isLiked': false,
    }
  ];

  void _toggleLike(int index) {
    setState(() {
      _reviews[index]['isLiked'] = !_reviews[index]['isLiked'];
      if (_reviews[index]['isLiked']) {
        _reviews[index]['likes']++;
      } else {
        _reviews[index]['likes']--;
      }
    });
  }

  void _showLogReviewModal(BuildContext context, AppState appState) {
    if (!appState.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.signInToReview), backgroundColor: Colors.redAccent));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      return; 
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C3440),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text.writeReview, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(widget.movieData['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 40,
                        icon: Icon(index < _userRating ? Icons.star : Icons.star_border, color: const Color(0xFF00E054)),
                        onPressed: () => setModalState(() => _userRating = index + 1.0),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reviewController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: text.reviewModalHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF14181C),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      appState.addToDiary(widget.movieData, _userRating, _reviewController.text.isEmpty ? text.noReview : _reviewController.text);
                      setState(() {
                        _reviews.insert(0, {
                          'user': appState.userName, 'rating': _userRating, 'text': _reviewController.text.isEmpty ? text.noReview : _reviewController.text, 'likes': 0, 'isLiked': false,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.reviewAdded), backgroundColor: const Color(0xFF00E054)));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E054), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Text(text.saveReview, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    // Cek apakah film ini sudah ada di watchlist
    final isWatchlisted = appState.isInWatchlist(widget.movieData);

    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      body: DefaultTabController(
        length: 5,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF14181C),
              leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              title: Text(widget.movieData['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(widget.movieData['image'], fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xFF14181C)], stops: [0.4, 1.0])),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.movieData['title'], style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('${widget.movieData['year']} • ${text.directedBy}', style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1)),
                              const SizedBox(height: 4),
                              Text(widget.movieData['director'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFF445566), borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                                    const SizedBox(width: 4),
                                    Text(text.trailer, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 90, height: 135,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(image: NetworkImage(widget.movieData['image']), fit: BoxFit.cover),
                            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(widget.movieData['tagline'], style: const TextStyle(color: Color(0xFFB0C0D0), fontSize: 14, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Text(widget.movieData['synopsis'], style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFF2C3440)),
                    
                    // --- 3 TOMBOL UTAMA ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.visibility, label: text.watchAction, color: const Color(0xFF00E054),
                          onTap: () {
                            if (!appState.isLoggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.signInFirst), backgroundColor: Colors.redAccent));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.markedWatched(widget.movieData['title'])), backgroundColor: const Color(0xFF00E054)));
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.article, label: text.reviewAction, color: const Color(0xFF8A9BAE),
                          onTap: () => _showLogReviewModal(context, appState),
                        ),
                         
                        // TOMBOL WATCHLIST DINAMIS (Bisa jadi Unwatchlist)
                        _buildActionButton(
                          icon: isWatchlisted ? Icons.remove_circle : Icons.add_circle, // Ikon berubah
                          label: isWatchlisted ? text.watchlistRemove : text.watchlistAdd, // Teks berubah
                          color: isWatchlisted ? Colors.redAccent : const Color(0xFF40BCF4), // Warna berubah jadi merah jika sudah ada
                          onTap: () {
                            if (!appState.isLoggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.signInFirst), backgroundColor: Colors.redAccent));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                              return;
                            }
                             
                            // Logika Add / Remove
                            if (isWatchlisted) {
                              appState.removeFromWatchlist(widget.movieData);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.removedFromWatchlist), backgroundColor: Colors.redAccent));
                            } else {
                              appState.addToWatchlist(widget.movieData);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.addedToWatchlist), backgroundColor: const Color(0xFF00E054)));
                            }
                          },
                        ),
                      ],
                    ),
                     
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF2C3440)),
                    const SizedBox(height: 16),
                     
                    // --- BAGIAN ULASAN ---
                    Text(text.popularReviews, style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ..._reviews.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var review = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 16, backgroundColor: const Color(0xFF2C3440), child: Text(review['user'][0], style: const TextStyle(color: Color(0xFF00E054), fontWeight: FontWeight.bold))),
                                const SizedBox(width: 12),
                                Text(review['user'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                ...List.generate(5, (i) => Icon(i < review['rating'] ? Icons.star : Icons.star_border, color: const Color(0xFF00E054), size: 14)),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => _toggleLike(idx),
                                  child: Row(
                                    children: [
                                      Icon(review['isLiked'] ? Icons.favorite : Icons.favorite_border, color: review['isLiked'] ? Colors.redAccent : Colors.grey, size: 18),
                                      const SizedBox(width: 4),
                                      Text('${review['likes']}', style: TextStyle(color: review['isLiked'] ? Colors.redAccent : Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(review['text'], style: const TextStyle(color: Color(0xFFB0C0D0), fontSize: 15, height: 1.5)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  isScrollable: true, indicatorColor: const Color(0xFF00E054), indicatorWeight: 3, labelColor: Colors.white, unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: text.tabCast),
                    Tab(text: text.tabCrew),
                    Tab(text: text.tabDetails),
                    Tab(text: text.tabGenre),
                    Tab(text: text.tabReleases),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: TabBarView(
                  children: [
                    Center(child: Text(text.castPage, style: const TextStyle(color: Colors.grey))),
                    Center(child: Text(text.crewPage, style: const TextStyle(color: Colors.grey))),
                    Center(child: Text(text.detailsPage, style: const TextStyle(color: Colors.grey))),
                    Center(child: Text(text.genrePage, style: const TextStyle(color: Colors.grey))),
                    Center(child: Text(text.releasesPage, style: const TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
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