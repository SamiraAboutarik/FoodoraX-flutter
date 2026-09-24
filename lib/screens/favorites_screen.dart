import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';
import '../widgets/fade_in_item.dart';
import '../widgets/food_card.dart';
import 'food_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final void Function(String foodId) onToggleFavorite;
  final void Function(FoodItem food, int quantity) onAddToCart;

  const FavoritesScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _toggleFavorite(String foodId) {
    widget.onToggleFavorite(foodId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoriteFoods = foodItems
        .where((food) => widget.favoriteIds.contains(food.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favoriteFoods.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 255,
              ),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];

                return FadeInItem(
                  index: index,
                  child: FoodCard(
                    food: food,
                    isFavorite: true,
                    width: double.infinity,
                    onTap: () {
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
                    },
                    onAddToCart: () => widget.onAddToCart(food, 1),
                    onToggleFavorite: () => _toggleFavorite(food.id),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 70,
            color: AppColors.mutedText,
          ),
          const SizedBox(height: 16),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap the heart icon on a dish to save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.mutedText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}