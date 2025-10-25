import 'package:alisveris_sitesi/views/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alisveris_sitesi/models/cart_item_model.dart';
import 'package:alisveris_sitesi/services/cart_service.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/widgets/similar_product_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: Consumer<CartService>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Sepetinizde henüz ürün bulunmuyor.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 45.0,
                horizontal: 400.0,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 550,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'Sepetinizdeki Ürünler',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.grey),
                              const SizedBox(height: 0),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cart.items.length,
                                  itemBuilder: (ctx, index) {
                                    final CartItemModel cartItem = cart
                                        .items
                                        .values
                                        .toList()[index];
                                    final product = cartItem.product;

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 15,
                                      ),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  product['image'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['name'],
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    product['brand'],
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    product['price'],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onPressed: () {
                                                    cart.removeSingleItem(
                                                      product['name'] as String,
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  '${cartItem.quantity}',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  onPressed: () {
                                                    cart.addItem(product);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    cart.removeItem(
                                                      product['name'] as String,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),

                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 550,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Sipariş Özeti',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 30,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Toplam Tutar:',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            '${cart.totalAmount.toStringAsFixed(2)} ₺',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final cartService =
                                                Provider.of<CartService>(
                                                  context,
                                                  listen: false,
                                                );

                                            bool success = await cartService
                                                .checkout();

                                            if (success && context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Siparişiniz başarıyla oluşturuldu! Teşekkür ederiz.',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                ),
                                              );

                                              Navigator.of(
                                                context,
                                              ).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Homescreen(),
                                                ),
                                                (route) => false,
                                              );
                                            } else if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Sipariş oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Alışverişi Tamamla',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

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
                            child: Text('Öneriler yüklenemedi.'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final allProducts = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          data['id'] = doc.id;
                          return data;
                        }).toList();

                        final cartCategories = cart.items.values
                            .map((item) => item.product['category'] as String)
                            .toSet();
                        final recommendedProducts = allProducts.where((
                          product,
                        ) {
                          final isInCartCategory = cartCategories.contains(
                            product['category'],
                          );
                          final isAlreadyInCart = cart.items.containsKey(
                            product['name'],
                          );
                          return isInCartCategory && !isAlreadyInCart;
                        }).toList();
                        recommendedProducts.shuffle();
                        final finalRecommendations = recommendedProducts
                            .take(5)
                            .toList();

                        if (finalRecommendations.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: finalRecommendations.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 0 : 8.0,
                                right: 8.0,
                              ),
                              child: SimilarProductCard(
                                product: finalRecommendations[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
