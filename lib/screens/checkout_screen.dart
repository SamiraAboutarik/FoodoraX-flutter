import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const List<_PaymentOption> _options = [
    _PaymentOption('Cash on delivery', 'Pay when your order arrives', Icons.payments_outlined),
    _PaymentOption('Credit card', '•••• •••• •••• 4242', Icons.credit_card_rounded),
    _PaymentOption('Digital wallet', 'Apple Pay / Google Pay', Icons.account_balance_wallet_outlined),
  ];

  int selectedPayment = 0;
  bool isPlacing = false;

  Future<void> _placeOrder() async {
    setState(() => isPlacing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pop(context, _options[selectedPayment].title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        children: [
          _sectionTitle('Delivery address'),
          _buildAddress(),
          const SizedBox(height: 24),
          _sectionTitle('Payment method'),
          for (int i = 0; i < _options.length; i++) _buildPaymentOption(i),
          const SizedBox(height: 14),
          _sectionTitle('Order summary'),
          _buildSummary(),
        ],
      ),
      bottomNavigationBar: _buildPlaceOrderBar(),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
    );
  }

  Widget _buildAddress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.location_on_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 3),
                Text('Ait Melloul, Agadir', style: TextStyle(color: AppColors.mutedText, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index) {
    final option = _options[index];
    final selected = index == selectedPayment;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.primary : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(12)),
              child: Icon(option.icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(option.subtitle, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.mutedText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          for (final item in widget.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('${item.quantity}×', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.food.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                  ),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
          const Divider(height: 24),
          _row('Subtotal', '\$${widget.subtotal.toStringAsFixed(2)}'),
          _row('Delivery fee', widget.deliveryFee == 0 ? 'Free' : '\$${widget.deliveryFee.toStringAsFixed(2)}'),
          if (widget.discount > 0) _row('Discount (10%)', '-\$${widget.discount.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _row('Total', '\$${widget.total.toStringAsFixed(2)}', bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
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

  Widget _buildPlaceOrderBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isPlacing ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary,
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: isPlacing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 22, color: Colors.white54),
                      const SizedBox(width: 12),
                      Text('\$${widget.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentOption(this.title, this.subtitle, this.icon);
}