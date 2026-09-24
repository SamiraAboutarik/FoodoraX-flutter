import 'package:flutter/material.dart';
import 'dart:async';

import '../data/food_data.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';
import '../utils/category_icons.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import '../widgets/section_title.dart';
import '../widgets/skeleton.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'food_details_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Set<String> favoriteIds;
  final void Function(String foodId) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    String selectedAddress = 'Ait Melloul, Agadir';

  static const List<String> _addresses = [
    'Ait Melloul, Agadir',
    'Founty, Agadir',
    'Hay Mohammadi, Agadir',
    'Anza, Agadir',
  ];

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _pickAddress() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Deliver to', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.text)),
                const SizedBox(height: 12),
                for (final address in _addresses)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                    title: Text(address, style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: address == selectedAddress
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => selectedAddress = address);
                      Navigator.pop(sheetContext);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late List<CartItem> cart;

  bool isLoading = true;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
    _loadingTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get filteredFoods {
    if (selectedCategory == 'All') return foodItems;
    return foodItems.where((food) => food.category == selectedCategory).toList();
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  List<FoodItem> get searchResults {
    final query = searchQuery.trim().toLowerCase();
    return filteredFoods.where((food) {
      return food.name.toLowerCase().contains(query) ||
          food.category.toLowerCase().contains(query);
    }).toList();
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(FoodItem food) {
    setState(() {
      final index = cart.indexWhere((item) => item.food.id == food.id);
      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(food: food));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _toggleFavorite(String foodId) {
    widget.onToggleFavorite(foodId);
    setState(() {});
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      searchQuery = '';
    });
  }

  void _openFoodDetails(FoodItem food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailsScreen(
          food: food,
          favoriteIds: widget.favoriteIds,
          onToggleFavorite: widget.onToggleFavorite,
          onAddToCart: (selectedFood, quantity) {
            for (int i = 0; i < quantity; i++) {
              addToCart(selectedFood);
            }
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Future<void> _openCart() async {
    await Navigator.push<List<CartItem>>(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
    );
    if (mounted) setState(() {});
  }

  void _openExplore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreScreen(
          favoriteIds: widget.favoriteIds,
          onToggleFavorite: widget.onToggleFavorite,
          onAddToCart: (food, quantity) {
            for (int i = 0; i < quantity; i++) {
              addToCart(food);
            }
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(
          favoriteIds: widget.favoriteIds,
          onToggleFavorite: widget.onToggleFavorite,
          onAddToCart: (food, quantity) {
            for (int i = 0; i < quantity; i++) {
              addToCart(food);
            }
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearch()),
            if (!isSearching) SliverToBoxAdapter(child: _buildPromo()),
            SliverToBoxAdapter(child: _buildCategories()),
            if (isSearching)
              ..._buildSearchResults()
            else ...[
              SliverToBoxAdapter(
                child: SectionTitle(
                  title: selectedCategory == 'All' ? 'Popular Near You' : selectedCategory,
                  onSeeAll: _openExplore,
                ),
              ),
              SliverToBoxAdapter(child: _buildPopularFoods()),
              SliverToBoxAdapter(child: SectionTitle(title: 'Special Offers', onSeeAll: _openNotifications)),
              SliverToBoxAdapter(child: _buildOfferCard()),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _pickAddress,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: AppColors.primary, size: 17),
                      SizedBox(width: 4),
                      Text('Deliver to', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
                      Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.mutedText, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _openNotifications,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              GestureDetector(
                onTap: _openCart,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search for food...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mutedText),
            suffixIcon: searchQuery.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.mutedText),
                    onPressed: _clearSearch,
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPromo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 160,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFFFF8A65)]),
        ),
        child: ClipRect(
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('LIMITED TIME', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      const Text('30% OFF', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      const Text('On your first order', style: TextStyle(color: Colors.white, fontSize: 11)),
                      const SizedBox(height: 7),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: _openExplore,                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Order Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Flexible(
                flex: 0,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(Icons.local_pizza_rounded, color: Colors.white, size: 75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 105,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = category == selectedCategory;
              return CategoryChip(
                label: category,
                icon: categoryIcon(category),
                selected: selected,
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

   Widget _buildPopularFoods() {
    if (isLoading) return _buildPopularSkeleton();
    final foods = selectedCategory == 'All'
        ? filteredFoods.where((food) => food.isPopular).toList()
        : filteredFoods;
    return SizedBox(
      height: 260,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FoodCard(
              key: ValueKey('$selectedCategory-${food.id}'),
              food: food,
              isFavorite: widget.favoriteIds.contains(food.id),
              onTap: () => _openFoodDetails(food),
              onAddToCart: () => addToCart(food),
              onToggleFavorite: () => _toggleFavorite(food.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularSkeleton() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 15),
            child: FoodCardSkeleton(),
          );
        },
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    final results = searchResults;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Text(
            results.length == 1 ? '1 result' : '${results.length} results',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      if (results.isEmpty)
        SliverToBoxAdapter(child: _buildNoResults())
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 255,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final food = results[index];
                return FoodCard(
                  food: food,
                  isFavorite: widget.favoriteIds.contains(food.id),
                  width: double.infinity,
                  onTap: () => _openFoodDetails(food),
                  onAddToCart: () => addToCart(food),
                  onToggleFavorite: () => _toggleFavorite(food.id),
                );
              },
              childCount: results.length,
            ),
          ),
        ),
    ];
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 70, color: AppColors.mutedText),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          Text(
            'We couldn\'t find anything for "${searchQuery.trim()}".',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: _clearSearch,
            child: const Text(
              'Clear search',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(color: const Color(0xFFFFF0EC), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Free delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text('Get free delivery on orders above \$25.', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
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
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.mutedText,
      backgroundColor: Colors.white,
      elevation: 10,
      onTap: (index) {
        if (index == 1) {
          _openExplore();
        } else if (index == 2) {
          _openCart();
        } else if (index == 3) {
          _openFavorites();
        } else if (index == 4) {
          _openProfile();
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}