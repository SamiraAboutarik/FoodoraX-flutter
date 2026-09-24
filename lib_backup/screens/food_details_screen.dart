import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../theme/app_theme.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem food;
  final Function(FoodItem food, int quantity) onAddToCart;

  const FoodDetailsScreen({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  State<FoodDetailsScreen> createState() =>
      _FoodDetailsScreenState();
}

class _FoodDetailsScreenState
    extends State<FoodDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;

  double get totalPrice {
    return widget.food.price * quantity;
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.text,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? AppColors.primary
                          : AppColors.text,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                25,
                20,
                30,
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                      ),

                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.secondary,
                              size: 17,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${food.rating}',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '${food.reviews} reviews',
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 5,
                        height: 5,
                        decoration:
                            const BoxDecoration(
                          color: AppColors.mutedText,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        food.category,
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'About this food',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    food.description,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _ingredient(
                    Icons.local_pizza,
                    'Fresh dough',
                  ),

                  _ingredient(
                    Icons.circle,
                    'Mozzarella cheese',
                  ),

                  _ingredient(
                    Icons.eco_outlined,
                    'Fresh vegetables',
                  ),

                  _ingredient(
                    Icons.restaurant,
                    'Special sauce',
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onTap: decreaseQuantity,
                      ),

                      Container(
                        width: 55,
                        alignment: Alignment.center,
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _quantityButton(
                        icon: Icons.add,
                        onTap: increaseQuantity,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onAddToCart(
                          food,
                          quantity,
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              '$quantity × ${food.name} added to cart',
                            ),
                            behavior:
                                SnackBarBehavior.floating,
                          ),
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(
                            width: 1,
                            height: 22,
                            color: Colors.white54,
                          ),

                          const SizedBox(width: 12),

                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ingredient(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EC),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}