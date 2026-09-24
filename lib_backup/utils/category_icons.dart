import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Pizza':
      return Icons.local_pizza_rounded;
    case 'Burgers':
      return Icons.lunch_dining_rounded;
    case 'Sides':
      return Icons.fastfood_rounded;
    case 'Drinks':
      return Icons.local_drink_rounded;
    case 'Desserts':
      return Icons.icecream_rounded;
    default:
      return Icons.restaurant_rounded;
  }
}
