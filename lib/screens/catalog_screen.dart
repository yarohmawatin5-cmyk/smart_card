import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  final List<Product> dummyProducts = [
    Product(id: '1', name: 'Laptop RPL Pro', price: 12500000),
    Product(id: '2', name: 'Mouse Wireless', price: 250000),
    Product(id: '3', name: 'Keyboard Mechanical', price: 750000),
    Product(id: '4', name: 'Monitor 24 inch', price: 2100000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Catalog SMKN 3 Tuban'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Badge(
                label: Text('${cart.totalItems}'),
                isLabelVisible: cart.totalItems > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.devices, size: 40),
                  Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Rp ${product.price}'),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addToCart(product);
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: const Text('Tambah'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}