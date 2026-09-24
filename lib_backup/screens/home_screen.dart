import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';
import 'food_details_screen.dart';
import 'cart_screen.dart';
class HomeScreen extends StatefulWidget {
  final List<CartItem> cart;

  const HomeScreen({
    super.key,
    required this.cart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  late List<CartItem> cart;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
  }

  List<FoodItem> get filteredFoods {
    if (selectedCategory == 'All') {
      return foodItems;
    }

    return foodItems
        .where(
          (food) => food.category == selectedCategory,
        )
        .toList();
  }

  int get cartCount {
    return cart.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  void addToCart(FoodItem food) {
    setState(() {
      final index = cart.indexWhere(
        (item) => item.food.id == food.id,
      );

      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(
          CartItem(food: food),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.name} added to cart',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          milliseconds: 900,
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            SliverToBoxAdapter(
              child: _buildSearch(),
            ),

            SliverToBoxAdapter(
              child: _buildPromo(),
            ),

            SliverToBoxAdapter(
              child: _buildCategories(),
            ),

            SliverToBoxAdapter(
              child: _buildSectionTitle(
                'Popular Near You',
              ),
            ),

            SliverToBoxAdapter(
              child: _buildPopularFoods(),
            ),

            SliverToBoxAdapter(
              child: _buildSectionTitle(
                'Special Offers',
              ),
            ),

            SliverToBoxAdapter(
              child: _buildOfferCard(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 17,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Deliver to',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Ait Melloul, Agadir',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),

          const SizedBox(width: 10),

          Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  final updatedCart =
                      await Navigator.push<List<CartItem>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: cart,
                      ),
                    ),
                  );

                  if (updatedCart != null) {
                    setState(() {
                      cart = updatedCart;
                    });
                  }
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
              ),

              if (cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration:
                        const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for food...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.mutedText,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

Widget _buildPromo() {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: Container(
      height: 160,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFFFF8A65),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'LIMITED TIME',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  '30% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'On your first order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 7),

                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.local_pizza_rounded,
            color: Colors.white,
            size: 75,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),

        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 105,
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category =
                  categories[index];

              final selected =
                  category ==
                      selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory =
                        category;
                  });
                },
                child: Container(
                  width: 78,
                  margin:
                      const EdgeInsets.only(
                    right: 12,
                  ),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),
                        width: 65,
                        height: 65,
                        decoration:
                            BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(20),
                        ),
                        child: Icon(
                          categoryIcon(
                            category,
                          ),
                          color: selected
                              ? Colors.white
                              : AppColors
                                  .primary,
                          size: 30,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                          color: selected
                              ? AppColors.primary
                              : AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        14,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'See all',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularFoods() {
    final popular = filteredFoods
        .where(
          (food) => food.isPopular,
        )
        .toList();

    return SizedBox(
      height: 245,
      child: ListView.builder(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: popular.length,
        itemBuilder: (context, index) {
          final food = popular[index];

return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(
          food: food,
          onAddToCart: (selectedFood, quantity) {
            for (int i = 0; i < quantity; i++) {
              addToCart(selectedFood);
            }
          },
        ),
      ),
    );
  },

  child: Container(
    width: 180,
    margin: const EdgeInsets.only(
      right: 15,
    ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius
                              .vertical(
                        top: Radius.circular(
                          22,
                        ),
                      ),
                      child: Image.network(
                        food.imageUrl,
                        width: 180,
                        height: 125,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                          shape:
                              BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .favorite_border,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color:
                                AppColors
                                    .secondary,
                            size: 16,
                          ),

                          const SizedBox(
                            width: 3,
                          ),

                          Text(
                            '${food.rating}',
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: AppColors
                                  .mutedText,
                            ),
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          Text(
                            '(${food.reviews})',
                            style:
                                const TextStyle(
                              fontSize: 11,
                              color: AppColors
                                  .mutedText,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            '\$${food.price.toStringAsFixed(2)}',
                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .primary,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () =>
                                addToCart(food),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration:
                                  const BoxDecoration(
                                color: AppColors
                                    .primary,
                                shape:
                                    BoxShape
                                        .circle,
                              ),
                              child:
                                  const Icon(
                                Icons.add,
                                color:
                                    Colors.white,
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
          
        },
      ),
    );
  }

  Widget _buildOfferCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EC),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Free delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Get free delivery on orders above \$25.',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
          AppColors.primary,
      unselectedItemColor:
          AppColors.mutedText,
      backgroundColor: Colors.white,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_rounded,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore_outlined,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag_outlined,
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border,
          ),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}