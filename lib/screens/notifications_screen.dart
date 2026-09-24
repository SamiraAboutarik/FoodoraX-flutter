import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<_Notif> _items = [
    _Notif(Icons.local_offer_rounded, '30% OFF your first order', 'Use code WELCOME30 at checkout.', '2 min ago'),
    _Notif(Icons.delivery_dining_rounded, 'Free delivery unlocked', 'Orders above \$25 ship for free today.', '1 h ago'),
    _Notif(Icons.star_rounded, 'New: Double Cheeseburger', 'Try our new burger, now in Popular.', '3 h ago'),
    _Notif(Icons.favorite_rounded, 'Your favorites are on sale', 'Check the dishes you saved.', 'Yesterday'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final n = _items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(14)),
                  child: Icon(n.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(n.body, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(n.time, style: const TextStyle(color: AppColors.mutedText, fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Notif {
  final IconData icon;
  final String title;
  final String body;
  final String time;

  const _Notif(this.icon, this.title, this.body, this.time);
}