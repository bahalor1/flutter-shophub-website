import 'package:flutter/material.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore'a yazmak için

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController(text: 'Stokta');
  final _tagController = TextEditingController();
  String _selectedCategory = 'Elektronik';

  bool _isLoading = false;

  final List<String> categories = [
    'Elektronik',
    'Ev & Yaşam',
    'Giyim',
    'Kitap',
    'Spor & Outdoor',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text.trim(),
          'brand': _brandController.text.trim(),
          'price': _priceController.text.trim(),
          'image': _imageController.text.trim(),
          'category': _selectedCategory,
          'description': _descriptionController.text.trim(),
          'stock': _stockController.text.trim(),
          'tag': _tagController.text.trim(),

          'rating': 0.0,
          'reviewCount': 0,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ürün başarıyla eklendi!'),
              backgroundColor: Colors.green,
            ),
          );

          _nameController.clear();
          _brandController.clear();
          _priceController.clear();
          _imageController.clear();
          _descriptionController.clear();
          _stockController.text = 'Stokta';
          _tagController.clear();

          setState(() {
            _selectedCategory = categories[0];
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ürün eklenirken hata oluştu: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 100.0,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(/* ... kutu stili ... */),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Yeni Ürün Ekle',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 30,
                    endIndent: 50,
                    thickness: 4,
                    indent: 50,
                    color: Color.fromARGB(255, 45, 137, 212),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Ürün Adı'),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen ürün adı girin' : null,
                  ),
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Marka'),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen marka girin' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Fiyat (örn: 1299.99 ₺)',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen fiyat girin' : null,
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(labelText: 'Resim URL'),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen resim URL girin' : null,
                  ),
                  // Kategori Seçimi (Dropdown)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Lütfen bir kategori seçin' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Açıklama'),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen açıklama girin' : null,
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stok Durumu (örn: Stokta, Tükendi)',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen stok durumu girin' : null,
                  ),
                  TextFormField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: 'Etiket (örn: Yeni, Öne Çıkan)',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Lütfen etiket girin' : null,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _addProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Ürünü Kaydet',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
