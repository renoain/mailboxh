import 'package:flutter/material.dart';
import 'member_profile_page.dart'; 

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Data dummy dengan status Follow
  final List<Map<String, dynamic>> _allMembers = [
    {'name': 'Budi', 'username': '@budi_movies', 'initial': 'B', 'isFollowing': false},
    {'name': 'Siti', 'username': '@siti_reviews', 'initial': 'S', 'isFollowing': true},
    {'name': 'Andi', 'username': '@andi_films', 'initial': 'A', 'isFollowing': false},
    {'name': 'Rina', 'username': '@rina_watch', 'initial': 'R', 'isFollowing': false},
    {'name': 'Joko', 'username': '@joko_cinema', 'initial': 'J', 'isFollowing': true},
    {'name': 'Dewi', 'username': '@dewi_critics', 'initial': 'D', 'isFollowing': false},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMembers = _allMembers.where((member) {
      return member['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             member['username']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        elevation: 0,
        title: const Text('Find Members', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search members...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2C3440),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: const Color(0xFF1B2228), borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2C3440),
                      child: Text(member['initial']!, style: const TextStyle(color: Color(0xFF00E054), fontWeight: FontWeight.bold)),
                    ),
                    title: Text(member['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(member['username']!, style: const TextStyle(color: Colors.grey)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Toggle status Follow
                        setState(() {
                          member['isFollowing'] = !member['isFollowing'];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: member['isFollowing'] ? const Color(0xFF2C3440) : const Color(0xFF00E054),
                        foregroundColor: member['isFollowing'] ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: member['isFollowing'] ? const BorderSide(color: Colors.grey) : BorderSide.none,
                      ),
                      child: Text(member['isFollowing'] ? 'Following' : 'Follow', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfilePage(memberName: member['name']!)));
                    },
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