import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';
import 'order_success_screen.dart';
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
    cart = widget.cart;
  }
  double get subtotal => cart.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (cart.isEmpty) return 0;
    return subtotal >= 25 ? 0 : 2.99;
  }

  double get discount => subtotal >= 30 ? subtotal * 0.10 : 0;

  double get total => subtotal + deliveryFee - discount;

  void increaseQuantity(int index) {
    setState(() {
      cart[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  void removeItem(int index) {
    final name = cart[index].food.name;
    setState(() {
      cart.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name removed from cart'), behavior: SnackBarBehavior.floating),
    );
  }
    Future<void> _checkout() async {
    final paymentMethod = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          items: cart,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          discount: discount,
          total: total,
        ),
      ),
    );
    if (paymentMethod == null || !mounted) return;

    final orderTotal = total;
    final itemCount = cart.fold<int>(0, (sum, item) => sum + item.quantity);
    cart.clear();

    Navigator.pushReplacement<void, List<CartItem>>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => OrderSuccessScreen(
          total: orderTotal,
          itemCount: itemCount,
          paymentMethod: paymentMethod,
        ),
      ),
      result: cart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, cart),
        ),
      ),
      body: cart.isEmpty ? _buildEmptyState() : _buildContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(color: Color(0xFFFFF0EC), shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_outlined, size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 6),
            const Text(
              'Looks like you haven\'t added anything yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Browse food', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            children: [
              _buildDeliveryBanner(),
              const SizedBox(height: 16),
              for (int i = 0; i < cart.length; i++) _buildItem(i),
            ],
          ),
        ),
        _buildSummary(),
      ],
    );
  }

  Widget _buildDeliveryBanner() {
    final remaining = 25 - subtotal;
    final text = remaining <= 0
        ? 'You unlocked free delivery!'
        : 'Add \$${remaining.toStringAsFixed(2)} more for free delivery';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.delivery_dining_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = cart[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item.food.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: const Color(0xFFFFF0EC),
                  child: const Icon(Icons.fastfood_rounded, color: AppColors.primary),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () => decreaseQuantity(index)),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    _qtyButton(Icons.add, () => increaseQuantity(index)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.mutedText),
            onPressed: () => removeItem(index),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            _summaryRow('Delivery fee', deliveryFee == 0 ? 'Free' : '\$${deliveryFee.toStringAsFixed(2)}'),
            if (discount > 0) _summaryRow('Discount (10%)', '-\$${discount.toStringAsFixed(2)}'),
            const Divider(height: 24),
            _summaryRow('Total', '\$${total.toStringAsFixed(2)}', bold: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      color: bold ? AppColors.text : AppColors.mutedText,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: bold ? style.copyWith(color: AppColors.primary) : style),
        ],
      ),
    );
  }
}