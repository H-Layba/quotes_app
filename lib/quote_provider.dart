import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class QuoteProvider with ChangeNotifier {
  List<String> _quotes = [
    "The only way to do great work is to love what you do.",
    "Success is not the key to happiness. Happiness is the key to success.",
    "Believe you can and you're halfway there.",
    "You are never too old to set another goal or to dream a new dream.",
    "In the middle of every difficulty lies opportunity.",
  ];

  List<String> _favorites = [];
  String _currentQuote = "The only way to do great work is to love what you do.";

  String get currentQuote => _currentQuote;

  List<String> get favorites => _favorites;

  QuoteProvider() {
    _loadFavorites();
  }

  void nextQuote() {
    int currentIndex = _quotes.indexOf(_currentQuote);
    int nextIndex = (currentIndex + 1) % _quotes.length;
    _currentQuote = _quotes[nextIndex];
    notifyListeners();
  }

  void addFavorite() {
    if (!_favorites.contains(_currentQuote)) {
      _favorites.add(_currentQuote);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFavorite(String quote) {
    _favorites.remove(quote);
    _saveFavorites();
    notifyListeners();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    if (savedFavorites != null) {
      _favorites = savedFavorites;
      notifyListeners();
    }
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites);
  }

  void shareQuote() {
    Share.share(_currentQuote, subject: 'Check out this quote!');
  }
}
