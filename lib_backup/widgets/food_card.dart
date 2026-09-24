import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../theme/app_theme.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleFavorite;
  final double width;

  const FoodCard({
    super.key,
    required this.food,
    required this.isFavorite,
    required this.onTap,
    required this.onAddToCart,
    required this.onToggleFavorite,
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(
                    food.imageUrl,
                    width: width,
                    height: 125,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onToggleFavorite,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: isFavorite
                            ? AppColors.primary
                            : AppColors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.secondary,
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${food.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${food.reviews})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
