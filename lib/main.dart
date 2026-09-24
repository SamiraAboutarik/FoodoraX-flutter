import 'package:flutter/material.dart';

import 'models/cart_item.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({super.key});

  @override
  State<FoodDeliveryApp> createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  final List<CartItem> cart = [];
  final Set<String> favoriteIds = {};

  void toggleFavorite(String foodId) {
    if (favoriteIds.contains(foodId)) {
      favoriteIds.remove(foodId);
    } else {
      favoriteIds.add(foodId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodoraX',
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Container(
          color: const Color(0xFFEDEDED),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        );
      },
      home: HomeScreen(
        cart: cart,
        favoriteIds: favoriteIds,
        onToggleFavorite: toggleFavorite,
      ),
    );
  }
}
