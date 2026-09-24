import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';
import '../utils/category_icons.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import 'food_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final void Function(String foodId) onToggleFavorite;
  final void Function(FoodItem food, int quantity) onAddToCart;

  const ExploreScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedCategory = 'All';

  List<FoodItem> get foods {
    if (selectedCategory == 'All') return foodItems;
    return foodItems.where((food) => food.category == selectedCategory).toList();
  }

  void _toggleFavorite(String foodId) {
    widget.onToggleFavorite(foodId);
    setState(() {});
  }

  void _openDetails(FoodItem food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(
          food: food,
          favoriteIds: widget.favoriteIds,
          onToggleFavorite: widget.onToggleFavorite,
          onAddToCart: widget.onAddToCart,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final list = foods;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 105,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryChip(
                  label: category,
                  icon: categoryIcon(category),
                  selected: category == selectedCategory,
                  onTap: () => setState(() => selectedCategory = category),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 255,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final food = list[index];
                return FoodCard(
                  food: food,
                  isFavorite: widget.favoriteIds.contains(food.id),
                  width: double.infinity,
                  onTap: () => _openDetails(food),
                  onAddToCart: () {
                    widget.onAddToCart(food, 1);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${food.name} added to cart'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(milliseconds: 900),
                      ),
                    );
                  },
                  onToggleFavorite: () => _toggleFavorite(food.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}