class CartItemModel {
  final Map<String, dynamic> product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
}
