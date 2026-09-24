import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label coming soon'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
  }

  void _showInfoSheet(BuildContext context, String title, IconData icon, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: Color(0xFFFFF0EC), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 30),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.text)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mutedText, fontSize: 14, height: 1.5)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out (demo)'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Log out', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 34),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guest User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
                      SizedBox(height: 4),
                      Text('guest@foodorax.com', style: TextStyle(color: AppColors.mutedText, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _tile(Icons.receipt_long_rounded, 'My Orders', () => _comingSoon(context, 'My Orders')),
          _tile(Icons.location_on_outlined, 'Delivery Addresses', () => _comingSoon(context, 'Delivery Addresses')),
          _tile(Icons.payment_rounded, 'Payment Methods', () => _comingSoon(context, 'Payment Methods')),
          _tile(
            Icons.local_offer_outlined,
            'Promo Codes',
            () => _showInfoSheet(context, 'WELCOME30', Icons.local_offer_rounded, 'Get 30% off your first order. Apply this code at checkout.'),
          ),
          _tile(Icons.notifications_none_rounded, 'Notifications', () => _openNotifications(context)),
          _tile(
            Icons.help_outline_rounded,
            'Help & Support',
            () => _showInfoSheet(context, 'Help & Support', Icons.support_agent_rounded, 'Need a hand? Contact us at support@foodorax.com. We reply within 24 hours.'),
          ),
          _tile(Icons.logout_rounded, 'Log out', () => _confirmLogout(context)),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text)),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
          ],
        ),
      ),
    );
  }
}