import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double total;
  final int itemCount;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.total,
    required this.itemCount,
    required this.paymentMethod,
  });

  String get orderNumber => '#FX${10000 + DateTime.now().millisecondsSinceEpoch % 90000}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 68),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Order placed!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your food is being prepared and\nwill be on its way soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mutedText, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                child: Column(
                  children: [
                    _row('Order number', orderNumber),
                    _row('Items', '$itemCount'),
                    _row('Payment', paymentMethod),
                    _row('Estimated delivery', '25 - 30 min'),
                    const Divider(height: 24),
                    _row('Total', '\$${total.toStringAsFixed(2)}', highlight: true),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: highlight ? 17 : 14,
              color: highlight ? AppColors.primary : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}