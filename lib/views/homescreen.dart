import 'package:flutter/material.dart';
import 'package:alisveris_sitesi/widgets/homebannerslider.dart';
import 'package:alisveris_sitesi/widgets/featured_products_section.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  final List<String> categories = [
    'Tüm Ürünler',
    'Elektronik',
    'Ev & Yaşam',
    'Giyim',
    'Kitap',
    'Spor & Outdoor',
  ];
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainHeader(
        scrollController: _scrollController,
        searchController: _searchController,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onLogoTap: () {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _selectedCategoryIndex = 0;
          });
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.asMap().entries.map((entry) {
                int index = entry.key;
                String categoryName = entry.value;
                bool isSelected = _selectedCategoryIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
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
                      categoryName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ürünler yüklenirken hata oluştu: ${snapshot.error}',
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Gösterilecek ürün bulunamadı.'),
                  );
                }

                final List<Map<String, dynamic>> allProducts = snapshot
                    .data!
                    .docs
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return data;
                    })
                    .toList();

                List<Map<String, dynamic>> displayProducts = allProducts;
                final String selectedCategory =
                    categories[_selectedCategoryIndex];

                if (selectedCategory != 'Tüm Ürünler') {
                  displayProducts = displayProducts.where((product) {
                    return product.containsKey('category') &&
                        product['category'] == selectedCategory;
                  }).toList();
                }

                if (_searchQuery.isNotEmpty) {
                  displayProducts = displayProducts.where((product) {
                    final productName = (product['name'] ?? '')
                        .toString()
                        .toLowerCase();
                    final query = _searchQuery.toLowerCase();
                    return productName.contains(query);
                  }).toList();
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      const HomeBannerSlider(),
                      const SizedBox(height: 50),

                      if (displayProducts.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                          child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Text(
                              'Aradığınız kriterlere uygun ürün bulunamadı.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ProductSection(
                          title: _searchQuery.isNotEmpty
                              ? "'$_searchQuery' için Sonuçlar"
                              : selectedCategory,
                          products: displayProducts,
                        ),

                      const SizedBox(height: 50),
                    ],
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
