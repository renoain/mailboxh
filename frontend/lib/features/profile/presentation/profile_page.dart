import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_state.dart';
import '../../auth/presentation/login_page.dart';
import '../../detail/presentation/movie_detail_page.dart';
import '../../feed/presentation/feed_page.dart'; 
import '../../members/presentation/members_page.dart'; 
import '../../settings/presentation/settings_page.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const AppText text = AppStrings.id;

  void _showEditProfileDialog(BuildContext context, AppState appState) {
    final usernameController = TextEditingController(text: appState.userUsername);
    final emailController = TextEditingController(text: appState.userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3440),
          title: Text(text.editProfile, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: text.usernameLabel,
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: text.email,
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(text.cancel, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                appState.updateProfile(usernameController.text, emailController.text);
                Navigator.pop(context);
              },
              child: Text(text.save, style: const TextStyle(color: Color(0xFF00E054), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memunculkan form buat List
  void _showCreateListDialog(BuildContext context, AppState appState) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3440),
          title: Text(text.createList, style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: text.listNameHint,
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(text.cancel, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // Simulasi menambahkan list dengan 3 film contoh
                  appState.addList(nameController.text, [
                    {'title': 'Digger', 'image': 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg', 'year': '2026', 'director': 'Alejandro G. Iñárritu', 'genre': 'Drama', 'duration': '129 mins', 'tagline': '', 'synopsis': ''},
                    {'title': 'Resident Evil', 'image': 'https://image.tmdb.org/t/p/w500/7QCbZcn2t25H8DkYq7eF4vO8uJk.jpg', 'year': '2024', 'director': 'Zach Cregger', 'genre': 'Horror', 'duration': '110 mins', 'tagline': '', 'synopsis': ''},
                    {'title': 'Spider-Man', 'image': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', 'year': '2026', 'director': 'Destin Daniel Cretton', 'genre': 'Action', 'duration': '140 mins', 'tagline': '', 'synopsis': ''},
                  ]);
                }
                Navigator.pop(context);
              },
              child: Text(text.createList, style: const TextStyle(color: Color(0xFF00E054), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // JIKA BELUM LOGIN
    if (!appState.isLoggedIn) {
      return Scaffold(
        backgroundColor: const Color(0xFF14181C),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFFFF8000), shape: BoxShape.circle)),
                    Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFF00E054), shape: BoxShape.circle)),
                    ),
                    Transform.translate(
                      offset: const Offset(-30, 0),
                      child: Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFF40BCF4), shape: BoxShape.circle)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(text.appName, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
                const Spacer(flex: 3),
                Container(height: 1, color: const Color(0xFF2C3440)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        child: Text(text.loginTitle, style: const TextStyle(color: Color(0xFFB0C0D0), fontSize: 22)),
                      ),
                      const SizedBox(height: 24),
                      Text(text.registerTitle, style: const TextStyle(color: Color(0xFFB0C0D0), fontSize: 22)),
                    ],
                  ),
                ),
                Container(height: 1, color: const Color(0xFF2C3440)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(text.artworkAttribution, style: const TextStyle(color: Color(0xFF6B7A8D), fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // JIKA SUDAH LOGIN
    return DefaultTabController(
      length: 3, // Sekarang ada 3 Tab (Diary, Watchlist, Lists)
      child: Scaffold(
        backgroundColor: const Color(0xFF14181C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF14181C),
          elevation: 0,
          title: Text(text.profileTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: false, 
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _showEditProfileDialog(context, appState),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF2C3440),
                        child: Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      appState.userUsername, 
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appState.userEmail, 
                      style: const TextStyle(color: Colors.grey, fontSize: 16)
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Statistik
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStat('${appState.diary.length}', text.tabDiary),
                        const SizedBox(width: 32),
                        _buildStat('${appState.watchlist.length}', text.statWatchlist),
                        const SizedBox(width: 32),
                        _buildStat('${appState.userLists.length}', text.statLists), // Dinamis
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // TOMBOL NAVIGASI
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedPage())),
                            icon: const Icon(Icons.rss_feed, color: Colors.white, size: 18),
                            label: Text(text.feedTitle, style: const TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF445566)),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MembersPage())),
                            icon: const Icon(Icons.people, color: Colors.black, size: 18),
                            label: Text(text.membersTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40BCF4)),
                          ),
                          // TOMBOL CREATE LIST
                          ElevatedButton.icon(
                            onPressed: () => _showCreateListDialog(context, appState),
                            icon: const Icon(Icons.add, color: Colors.black, size: 18),
                            label: Text(text.createList, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E054)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // TOMBOL LOGOUT
                    OutlinedButton.icon(
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false).logout();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                      label: Text(text.logout, style: const TextStyle(color: Colors.redAccent)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2C3440)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: const Color(0xFF00E054),
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: text.tabDiary),
                      Tab(text: text.watchlistTitle),
                      Tab(text: text.tabLists), // TAB BARU
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildDiaryTab(appState.diary),
              _buildWatchlistTab(appState.watchlist),
              _buildListsTab(appState.userLists), // ISI TAB BARU
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildDiaryTab(List<Map<String, dynamic>> diaryList) {
    if (diaryList.isEmpty) {
      return Center(child: Text(text.profileDiaryEmpty, style: const TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diaryList.length,
      itemBuilder: (context, index) {
        final movie = diaryList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF2C3440), width: 1))),
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 50, height: 75,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(image: NetworkImage(movie['image']), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie['title'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < movie['user_rating'] ? Icons.star : Icons.star_border, 
                          color: const Color(0xFF00E054), size: 14
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${movie['user_review']}"',
                      style: const TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWatchlistTab(List<Map<String, dynamic>> watchlist) {
    if (watchlist.isEmpty) {
      return Center(child: Text(text.watchlistEmpty, style: const TextStyle(color: Colors.grey)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2 / 3,
      ),
      itemCount: watchlist.length,
      itemBuilder: (context, index) {
        final movie = watchlist[index];
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
    );
  }

  // WIDGET UNTUK TAB LISTS
  Widget _buildListsTab(List<Map<String, dynamic>> userLists) {
    if (userLists.isEmpty) {
      return Center(child: Text(text.profileListsEmpty, style: const TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userLists.length,
      itemBuilder: (context, index) {
        final list = userLists[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              const Icon(Icons.format_list_bulleted, color: Color(0xFF00E054), size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(text.filmCount(list['movies'].length), style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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