import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/services/favorite_service.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:alisveris_sitesi/widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedCategory = 'Tüm Ürünler';

  final List<String> categories = [
    'Tüm Ürünler',
    'Elektronik',
    'Ev & Yaşam',
    'Giyim',
    'Kitap',
    'Spor & Outdoor',
  ];

  @override
  Widget build(BuildContext context) {
    final favoriteService = Provider.of<FavoriteService>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1D2951),
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map((category) {
                bool isSelected = _selectedCategory == category;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.cyan : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: favoriteService.favorites,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Favoriler yüklenirken bir hata oluştu: ${snapshot.error}',
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz favori ürününüz bulunmuyor.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                List<Map<String, dynamic>> favoriteProducts = snapshot.data!;

                List<Map<String, dynamic>> filteredFavorites = favoriteProducts
                    .where((product) {
                      if (_selectedCategory == 'Tüm Ürünler') return true;
                      return product['category'] == _selectedCategory;
                    })
                    .toList();

                if (filteredFavorites.isEmpty) {
                  return Center(
                    child: Text(
                      'Bu kategoride favori ürününüz bulunmuyor.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: filteredFavorites.map((productMap) {
                      return SizedBox(
                        width: 280,
                        child: ProductCard(product: productMap),
                      );
                    }).toList(),
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
