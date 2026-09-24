import 'package:flutter/material.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      home: const HomeScreen(),
    );
  }
}

// ============ MODELS ============
class FoodItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  double get totalPrice => food.price * quantity;
}

// ============ DATA ============
final List<FoodItem> menuItems = [
  FoodItem(
    name: 'Supreme Pan Pizza',
    description: 'Loaded with veggies, mushrooms & more',
    price: 12.49,
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    category: 'Pizza',
  ),
  FoodItem(
    name: 'Cheese Lovers Pizza',
    description: 'Extra cheese, extra delight',
    price: 11.49,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    category: 'Pizza',
  ),
  FoodItem(
    name: 'BBQ Chicken Pizza',
    description: 'Tender chicken with smoky BBQ',
    price: 12.99,
    imageUrl: 'https://images.unsplash.com/photo-1594007654729-407eedc4be65',
    category: 'Pizza',
  ),
  FoodItem(
    name: 'Garlic Bread',
    description: 'Crispy, buttery, garlicky',
    price: 4.99,
    imageUrl: 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c',
    category: 'Sides',
  ),
  FoodItem(
    name: 'Chicken Wings',
    description: 'Spicy grilled wings',
    price: 7.49,
    imageUrl: 'https://images.unsplash.com/photo-1608039755401-742074f0548d',
    category: 'Sides',
  ),
  FoodItem(
    name: 'Coca-Cola',
    description: 'Ice-cold refreshment',
    price: 2.49,
    imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7',
    category: 'Drinks',
  ),
  FoodItem(
    name: 'Fresh Orange Juice',
    description: 'Squeezed daily',
    price: 3.49,
    imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba',
    category: 'Drinks',
  ),
];

final List<String> categories = ['All', 'Pizza', 'Sides', 'Drinks'];

// ============ HOME SCREEN ============
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  List<CartItem> cart = [];

  List<FoodItem> get filteredItems {
    if (selectedCategory == 'All') return menuItems;
    return menuItems.where((item) => item.category == selectedCategory).toList();
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(FoodItem food) {
    setState(() {
      final existing = cart.where((c) => c.food.name == food.name).toList();
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        cart.add(CartItem(food: food));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> openCart() async {
    final updatedCart = await Navigator.push<List<CartItem>>(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
    );
    if (updatedCart != null) {
      setState(() => cart = updatedCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Pizza Hut'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: openCart,
              ),
              if (cartCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$cartCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.red,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            item.imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${item.price}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => addToCart(item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}

// ============ CART SCREEN ============
class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cart;

  @override
  void initState() {
    super.initState();
    cart = List.from(widget.cart);
  }

  double get total => cart.fold(0, (sum, item) => sum + item.totalPrice);

  void increment(int index) {
    setState(() => cart[index].quantity++);
  }

  void decrement(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, cart);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Your Cart'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, cart),
          ),
        ),
        body: cart.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty 🛒',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.food.imageUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.food.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.food.price} x ${item.quantity}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => decrement(index),
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.red),
                                onPressed: () => increment(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        bottomNavigationBar: cart.isEmpty
            ? null
            : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total', style: TextStyle(color: Colors.grey)),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order placed! 🎉')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Checkout',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}