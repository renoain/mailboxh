import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String userName = 'Guest User'; 
  String userUsername = 'guest123';
  String userEmail = 'guest@email.com'; 

  final List<Map<String, dynamic>> watchlist = [];
  final List<Map<String, dynamic>> diary = [];
  
  // TAMBAHAN: List untuk menyimpan daftar buatan user
  final List<Map<String, dynamic>> userLists = []; 

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile(String newUsername, String newEmail) {
    userUsername = newUsername;
    userEmail = newEmail;
    userName = newUsername;
    notifyListeners(); 
  }

  void addToWatchlist(Map<String, dynamic> movie) {
    if (!isInWatchlist(movie)) {
      watchlist.add(movie);
      notifyListeners(); 
    }
  }

  bool isInWatchlist(Map<String, dynamic> movie) {
    return watchlist.any((m) => m['title'] == movie['title']);
  }

  void removeFromWatchlist(Map<String, dynamic> movie) {
    watchlist.removeWhere((m) => m['title'] == movie['title']);
    notifyListeners();
  }

  void addToDiary(Map<String, dynamic> movie, double rating, String review) {
    removeFromWatchlist(movie);
    diary.add({
      ...movie,
      'user_rating': rating,
      'user_review': review,
      'date_added': DateTime.now(),
    });
    notifyListeners();
  }

  // TAMBAHAN: Fungsi untuk membuat List Baru
  void addList(String listName, List<Map<String, dynamic>> movies) {
    userLists.add({
      'name': listName,
      'movies': movies,
    });
    notifyListeners();
  }
}