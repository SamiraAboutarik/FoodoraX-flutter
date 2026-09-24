import 'package:flutter/material.dart';

class Ingredient {
  final IconData icon;
  final String name;

  const Ingredient(this.icon, this.name);
}

List<Ingredient> ingredientsFor(String category) {
  switch (category.trim().toLowerCase()) {
    case 'pizza':
      return const [
        Ingredient(Icons.bakery_dining_outlined, 'Fresh dough'),
        Ingredient(Icons.circle, 'Mozzarella cheese'),
        Ingredient(Icons.eco_outlined, 'Fresh vegetables'),
        Ingredient(Icons.restaurant, 'Special tomato sauce'),
      ];
    case 'burgers':
      return const [
        Ingredient(Icons.bakery_dining_outlined, 'Toasted bun'),
        Ingredient(Icons.lunch_dining, 'Grilled patty'),
        Ingredient(Icons.eco_outlined, 'Lettuce and tomato'),
        Ingredient(Icons.water_drop_outlined, 'Signature sauce'),
      ];
    case 'sides':
      return const [
        Ingredient(Icons.grain, 'Golden crispy coating'),
        Ingredient(Icons.spa_outlined, 'Fresh herbs'),
        Ingredient(Icons.local_fire_department_outlined, 'Hot spices'),
        Ingredient(Icons.water_drop_outlined, 'Dipping sauce'),
      ];
    case 'drinks':
      return const [
        Ingredient(Icons.ac_unit, 'Served ice cold'),
        Ingredient(Icons.water_drop_outlined, 'Fresh and refreshing'),
        Ingredient(Icons.eco_outlined, 'Natural flavors'),
      ];
    case 'desserts':
      return const [
        Ingredient(Icons.cookie_outlined, 'Soft and fluffy base'),
        Ingredient(Icons.cake_outlined, 'Rich creamy filling'),
        Ingredient(Icons.icecream_outlined, 'Sweet toppings'),
      ];
    default:
      return const [
        Ingredient(Icons.eco_outlined, 'Fresh ingredients'),
        Ingredient(Icons.restaurant, 'Special recipe'),
      ];
  }
}