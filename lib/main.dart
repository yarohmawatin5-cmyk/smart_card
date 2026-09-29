import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const SmartCartApp(),
    ),
  );
}

// =====================================================
// MODEL PRODUK
// =====================================================

class Product {
  final String id;
  final String name;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
  });
}

// =====================================================
// DATA PRODUK
// =====================================================

const List<Product> products = [
  Product(
    id: '1',
    name: 'Laptop RPL Pro',
    price: 12500000,
    icon: Icons.laptop_mac,
    color: Color(0xFF2563EB),
  ),
  Product(
    id: '2',
    name: 'Mouse Wireless',
    price: 250000,
    icon: Icons.mouse,
    color: Color(0xFF0891B2),
  ),
  Product(
    id: '3',
    name: 'Keyboard Mechanical',
    price: 450000,
    icon: Icons.keyboard,
    color: Color(0xFF7C3AED),
  ),
  Product(
    id: '4',
    name: 'Headset Gaming',
    price: 350000,
    icon: Icons.headset_mic,
    color: Color(0xFFDB2777),
  ),
  Product(
    id: '5',
    name: 'Flashdisk 64GB',
    price: 95000,
    icon: Icons.usb,
    color: Color(0xFF059669),
  ),
  Product(
    id: '6',
    name: 'Monitor LED',
    price: 1850000,
    icon: Icons.desktop_windows,
    color: Color(0xFFEA580C),
  ),
];

// =====================================================
// CART ITEM
// =====================================================

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total {
    return product.price * quantity;
  }
}

// =====================================================
// CART PROVIDER
// =====================================================

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems {
    return _items.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  double get totalPrice {
    return _items.values.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        product: product,
      );
    }

    notifyListeners();
  }

  void increase(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decrease(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// =====================================================
// FORMAT RUPIAH
// =====================================================

String rupiah(double value) {
  return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(1)}.',
      )}';
}

// =====================================================
// APP
// =====================================================

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cart',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),

      home: const HomePage(),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(
            search.toLowerCase(),
          );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                24,
                25,
                24,
                28,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F766E),
                    Color(0xFF0891B2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // TOP HEADER
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              'E-Catalog SMKN 3 Tuban',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // CART
                      Consumer<CartProvider>(
                        builder: (
                          context,
                          cart,
                          child,
                        ) {
                          return Stack(
                            clipBehavior: Clip.none,

                            children: [
                              Container(
                                width: 46,
                                height: 46,

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),

                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CartPage(),
                                      ),
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Color(0xFF0F766E),
                                  ),
                                ),
                              ),

                              if (cart.totalItems > 0)
                                Positioned(
                                  right: -5,
                                  top: -6,

                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(6),

                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Text(
                                      '${cart.totalItems}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // WELCOME TEXT
                  const Text(
                    'Temukan Produk Favoritmu 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Belanja kebutuhan teknologi dengan mudah.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SEARCH
                  Container(
                    height: 52,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },

                      decoration: const InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),

                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF0F766E),
                        ),

                        border: InputBorder.none,

                        contentPadding:
                            EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================
            // TITLE PRODUK
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                22,
                22,
                12,
              ),

              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Produk Pilihan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF7F3),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      '${filteredProducts.length} Produk',
                      style: const TextStyle(
                        color: Color(0xFF0F766E),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================
            // GRID PRODUK
            // =================================================

            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        20,
                      ),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.70,
                      ),

                      itemCount: filteredProducts.length,

                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,

        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartPage(),
              ),
            );
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            selectedIcon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// PRODUCT CARD
// =====================================================

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // PRODUCT ICON
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      product.color.withOpacity(0.18),
                      product.color.withOpacity(0.06),
                    ],

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius:
                      BorderRadius.circular(17),
                ),

                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      product.icon,
                      size: 45,
                      color: product.color,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // PRODUCT NAME
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 5),

            // PRICE
            Text(
              rupiah(product.price),

              style: TextStyle(
                color: product.color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 40,

              child: ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<CartProvider>()
                      .add(product);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.name} ditambahkan',
                      ),

                      duration:
                          const Duration(seconds: 1),

                      behavior:
                          SnackBarBehavior.floating,

                      backgroundColor:
                          const Color(0xFF0F766E),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.add_shopping_cart,
                  size: 16,
                ),

                label: const Text(
                  'Tambah',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: product.color,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CART PAGE
// =====================================================

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,

        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return const SizedBox();
              }

              return IconButton(
                onPressed: () {
                  cart.clear();
                },
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: Color(0xFFCBD5E1),
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Yuk pilih produk yang kamu butuhkan!',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: cart.items.length,

                  itemBuilder: (context, index) {
                    return CartItemCard(
                      item: cart.items[index],
                    );
                  },
                ),
              ),

              // TOTAL
              Container(
                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.only(
                    topLeft:
                        Radius.circular(28),
                    topRight:
                        Radius.circular(28),
                  ),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'Total Belanja',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),

                        Text(
                          rupiah(
                            cart.totalPrice,
                          ),

                          style: const TextStyle(
                            color:
                                Color(0xFF0F766E),
                            fontSize: 21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Checkout berhasil diproses.',
                              ),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF0F766E,
                          ),

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),

                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================
// CART ITEM
// =====================================================

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,

            decoration: BoxDecoration(
              color: item.product.color
                  .withOpacity(0.12),

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              item.product.icon,
              color: item.product.color,
              size: 34,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  item.product.name,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  rupiah(
                    item.product.price,
                  ),

                  style: TextStyle(
                    color:
                        item.product.color,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // MINUS
          IconButton(
            onPressed: () {
              context
                  .read<CartProvider>()
                  .decrease(
                    item.product.id,
                  );
            },

            icon: const Icon(
              Icons.remove_circle_outline,
            ),

            color: Colors.grey,
          ),

          Text(
            '${item.quantity}',

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          // PLUS
          IconButton(
            onPressed: () {
              context
                  .read<CartProvider>()
                  .increase(
                    item.product.id,
                  );
            },

            icon: const Icon(
              Icons.add_circle,
            ),

            color: const Color(
              0xFF0F766E,
            ),
          ),
        ],
      ),
    );
  }
}