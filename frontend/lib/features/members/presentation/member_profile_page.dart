import 'package:flutter/material.dart';

class MemberProfilePage extends StatelessWidget {
  final String memberName;

  const MemberProfilePage({super.key, required this.memberName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF14181C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF14181C),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(memberName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF2C3440),
                      child: Text(memberName[0], style: const TextStyle(color: Color(0xFF00E054), fontSize: 40, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Text(memberName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('@${memberName.toLowerCase()}', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStat('124', 'Films'),
                        const SizedBox(width: 32),
                        _buildStat('45', 'Reviews'),
                        const SizedBox(width: 32),
                        _buildStat('12', 'Lists'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF2C3440)),
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorColor: Color(0xFF00E054),
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [Tab(text: 'Recent Activity'), Tab(text: 'Favorites')],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF2C3440), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(width: 50, height: 75, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.movie, color: Colors.white54)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reviewed Movie ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(children: List.generate(4, (i) => const Icon(Icons.star, color: Color(0xFF00E054), size: 14))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2 / 3),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(image: NetworkImage('https://picsum.photos/seed/fav${index + 1}/200/300'), fit: BoxFit.cover),
                    ),
                  );
                },
              ),
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