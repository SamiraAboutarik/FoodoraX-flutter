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
  State<FoodDeliveryApp> createState() =>
      _FoodDeliveryAppState();
}

class _FoodDeliveryAppState
    extends State<FoodDeliveryApp> {

  final List<CartItem> cart = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'FoodoraX',

      theme: AppTheme.lightTheme,

      home: HomeScreen(
        cart: cart,
      ),
    );
  }
}