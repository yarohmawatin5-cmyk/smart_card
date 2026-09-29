class Product {
  final String id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}