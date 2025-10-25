import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Set<String> _favoriteProductNames = {};

  FavoriteService() {
    _loadFavorites();

    _auth.authStateChanges().listen((user) {
      _loadFavorites();
    });
  }

  Future<List<Map<String, dynamic>>> get favorites async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Favoriler çekilirken hata: $e");
      return [];
    }
  }

  Set<String> get favoriteProductNames => _favoriteProductNames;

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) {
      _favoriteProductNames = {};
      notifyListeners();
      return;
    }
    try {
      final favs = await favorites;
      _favoriteProductNames = favs.map((fav) => fav['name'] as String).toSet();
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Favoriler yüklenirken hata: $e");
      _favoriteProductNames = {};
      notifyListeners();
    }
  }

  bool isFavorite(Map<String, dynamic> product) {
    return _favoriteProductNames.contains(product['name']);
  }

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final productName = product['name'] as String;

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productName);

    try {
      if (isFavorite(product)) {
        await favRef.delete();
        _favoriteProductNames.remove(productName);
      } else {
        await favRef.set(product);
        _favoriteProductNames.add(productName);
      }
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Favori güncellenirken hata: $e");

      _loadFavorites();
    }
  }
}
