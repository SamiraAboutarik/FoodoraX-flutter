import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category.trim().toLowerCase()) {
    case 'all':
      return Icons.apps_rounded;
    case 'pizza':
      return Icons.local_pizza_rounded;
    case 'burgers':
      return Icons.lunch_dining_rounded;
    case 'sides':
      return Icons.kebab_dining_rounded;
    case 'drinks':
      return Icons.local_drink_rounded;
    case 'desserts':
      return Icons.icecream_rounded;
    default:
      return Icons.restaurant_rounded;
  }
}