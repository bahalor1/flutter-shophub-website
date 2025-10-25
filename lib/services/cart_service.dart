import 'package:flutter/material.dart';
import 'package:alisveris_sitesi/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, CartItemModel> _items = {};

  CartService() {
    _loadCart();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadCart();
      } else {
        _items = {};
        notifyListeners();
      }
    });
  }

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      final priceString = cartItem.product['price'] as String;

      try {
        final price = double.parse(priceString.replaceAll(' ₺', ''));
        total += price * cartItem.quantity;
      } catch (e) {
        // ignore: avoid_print
        print("Fiyat parse edilirken hata: $priceString - Hata: $e");
      }
    });
    return total;
  }

  CollectionReference<Map<String, dynamic>>? _getCartCollectionRef() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('cartItems');
  }

  Future<void> _loadCart() async {
    final cartCollectionRef = _getCartCollectionRef();
    if (cartCollectionRef == null) {
      _items = {};
      notifyListeners();
      return;
    }

    try {
      final snapshot = await cartCollectionRef.get();

      _items = {
        for (var doc in snapshot.docs)
          doc.id: CartItemModel(
            product: doc.data()['product'],
            quantity: doc.data()['quantity'] ?? 1,
          ),
      };
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Sepet yüklenirken hata: $e");
      _items = {};
      notifyListeners();
    }
  }

  Future<void> addItem(Map<String, dynamic> product) async {
    final cartCollectionRef = _getCartCollectionRef();
    if (cartCollectionRef == null) return;

    final productId = product['name'] as String;
    final itemRef = cartCollectionRef.doc(productId);

    try {
      if (_items.containsKey(productId)) {
        _items[productId]!.quantity++;
      } else {
        _items[productId] = CartItemModel(product: product, quantity: 1);
      }
      notifyListeners();

      await itemRef.set({
        'product': product,
        'quantity': _items[productId]!.quantity,
      });
    } catch (e) {
      // ignore: avoid_print
      print("Sepete eklenirken hata: $e");

      _loadCart();
    }
  }

  Future<void> removeSingleItem(String productName) async {
    final cartCollectionRef = _getCartCollectionRef();
    if (cartCollectionRef == null || !_items.containsKey(productName)) return;

    final itemRef = cartCollectionRef.doc(productName);

    try {
      if (_items[productName]!.quantity > 1) {
        _items[productName]!.quantity--;
        notifyListeners();

        await itemRef.update({'quantity': _items[productName]!.quantity});
      } else {
        _items.remove(productName);
        notifyListeners();
        await itemRef.delete();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Adet azaltılırken hata: $e");
      _loadCart();
    }
  }

  Future<void> removeItem(String productName) async {
    final cartCollectionRef = _getCartCollectionRef();
    if (cartCollectionRef == null || !_items.containsKey(productName)) return;

    final itemRef = cartCollectionRef.doc(productName);

    try {
      _items.remove(productName);
      notifyListeners();

      await itemRef.delete();
    } catch (e) {
      // ignore: avoid_print
      print("Sepetten çıkarılırken hata: $e");
      _loadCart();
    }
  }

  Future<void> clear() async {
    final cartCollectionRef = _getCartCollectionRef();
    if (cartCollectionRef == null) return;

    try {
      _items.clear();
      notifyListeners();

      final batch = _firestore.batch();
      final snapshot = await cartCollectionRef.get();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      // ignore: avoid_print
      print("Sepet temizlenirken hata: $e");
      _loadCart();
    }
  }

  Future<bool> checkout() async {
    final user = _auth.currentUser;

    if (user == null || _items.isEmpty) return false;

    final ordersCollectionRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders');

    try {
      await ordersCollectionRef.add({
        'orderDate': Timestamp.now(),
        'totalAmount': totalAmount,

        'items': _items.values
            .map(
              (cartItem) => {
                'product': cartItem.product,
                'quantity': cartItem.quantity,
              },
            )
            .toList(),
      });

      await clear();

      return true;
    } catch (e) {
      // ignore: avoid_print
      print("Checkout sırasında hata: $e");

      return false;
    }
  }
}
