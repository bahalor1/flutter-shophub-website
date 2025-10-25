import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 600.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sipariş Geçmişim',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: user != null
                    ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('orders')
                          .orderBy('orderDate', descending: true)
                          .snapshots()
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Siparişler yüklenirken bir hata oluştu: ${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz hiç sipariş vermediniz.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final orders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final orderData =
                          orders[index].data() as Map<String, dynamic>;
                      final orderDate = (orderData['orderDate'] as Timestamp)
                          .toDate();
                      final totalAmount = orderData['totalAmount'] as double;
                      final items = orderData['items'] as List<dynamic>;

                      return Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(16.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sipariş Tarihi:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formatter.format(orderDate),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                'Toplam: ${totalAmount.toStringAsFixed(2)} ₺',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),

                          children: items.map<Widget>((item) {
                            final product =
                                item['product'] as Map<String, dynamic>;
                            final quantity = item['quantity'] as int;

                            return ListTile(
                              leading: Image.network(
                                product['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(product['name']),
                              subtitle: Text(product['price']),
                              trailing: Text('Adet: $quantity'),
                            );
                          }).toList(),
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
    );
  }
}
