import 'dart:math';
import 'package:alisveris_sitesi/views/homescreen.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:alisveris_sitesi/widgets/similar_product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/services/favorite_service.dart';
import 'package:alisveris_sitesi/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _similarProductsScrollController = ScrollController();
  int _quantity = 1;
  int _selectedTabIndex = 0;

  final double rating = 1.5 + Random().nextDouble() * 1.5;
  final int reviewCount = 20 + Random().nextInt(500);

  @override
  void dispose() {
    _similarProductsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = widget.product['category'];
    final currentProductName = widget.product['name'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Homescreen()),
            (route) => false,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 330.0,
                vertical: 50.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.product['image'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),

                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const SizedBox(height: 30),
                          Text(
                            widget.product['name'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product['brand'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              ..._buildStarRating(rating),
                              const SizedBox(width: 8),
                              Text(
                                '$reviewCount değerlendirme',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            widget.product['price'],
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product['stock'],
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.product['stock'] == 'Stokta'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(height: 1, thickness: 1),

                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                const Text(
                                  'Adet:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 250,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final cart = Provider.of<CartService>(
                                      context,
                                      listen: false,
                                    );
                                    for (int i = 0; i < _quantity; i++) {
                                      cart.addItem(widget.product);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$_quantity adet ${widget.product['name']} sepete eklendi!',
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      45,
                                      137,
                                      212,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Sepete Ekle',
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Consumer<FavoriteService>(
                                  builder: (context, favoriteService, child) {
                                    final bool isFavorite = favoriteService
                                        .isFavorite(widget.product);
                                    return OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          favoriteService.toggleFavorite(
                                            widget.product,
                                          );
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.redAccent
                                            : Colors.grey.shade600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 330, right: 330),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        children: [
                          _buildTabButton('Ürün Açıklaması', 0),
                          _buildTabButton('Değerlendirmeler ($reviewCount)', 1),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 20),

                    _selectedTabIndex == 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 50, right: 20),
                            child: Text(
                              widget.product['description'] ??
                                  'Bu ürün için bir açıklama mevcut değil.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 50, right: 20),

                            child: Text(
                              'Kullanıcı Yorumları buraya gelecek...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 340.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Benzer Ürünler',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 320,
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Ürünler yüklenemedi.'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('Benzer ürün bulunamadı.'),
                          );
                        }

                        final allProducts = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          data['id'] = doc.id;
                          return data;
                        }).toList();

                        final similarProducts = allProducts.where((product) {
                          return product.containsKey('category') &&
                              product['category'] == currentCategory &&
                              product['name'] != currentProductName;
                        }).toList();

                        if (similarProducts.isEmpty) {
                          return const Center(
                            child: Text('Bu kategoride başka ürün bulunamadı.'),
                          );
                        }

                        return ListView.builder(
                          controller: _similarProductsScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: similarProducts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SimilarProductCard(
                                product: similarProducts[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Yıldızları oluşturan yardımcı bir fonksiyon
  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (i <= rating) {
        icon = Icons.star;
      } else if (i - 0.5 <= rating) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, color: Colors.amber, size: 20));
    }
    return stars;
  }

  // Sekme butonlarını oluşturan yardımcı bir fonksiyon
  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Color.fromARGB(255, 45, 137, 212)
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Color.fromARGB(255, 45, 137, 212)
                : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
