import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;

  const CartScreen({
    super.key,
    required this.cart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cart;

  @override
  void initState() {
    super.initState();

    cart = List.from(widget.cart);
  }

  double get subtotal {
    return cart.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  double get deliveryFee {
    if (cart.isEmpty) {
      return 0;
    }

    return subtotal >= 25 ? 0 : 2.99;
  }

  double get discount {
    if (subtotal >= 30) {
      return subtotal * 0.10;
    }

    return 0;
  }

  double get total {
    return subtotal + deliveryFee - discount;
  }

  void increaseQuantity(int index) {
    setState(() {
      cart[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  void removeItem(int index) {
    final name = cart[index].food.name;

    setState(() {
      cart.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name removed from cart'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.pop(context, cart);
          },
        ),

        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: true,
      ),

      body: cart.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      20,
                    ),
                    children: [
                      _buildDeliveryCard(),

                      const SizedBox(height: 20),

                      const Text(
                        'Your Items',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      ...List.generate(
                        cart.length,
                        (index) {
                          return _buildCartItem(
                            index,
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      _buildPromoCard(),

                      const SizedBox(height: 20),

                      _buildSummary(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                _buildCheckoutButton(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EC),
                borderRadius:
                    BorderRadius.circular(35),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 55,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Looks like you haven’t added anything yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start Ordering',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EC),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Deliver to',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Ait Melloul, Agadir',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {},
            child: const Text(
              'Change',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = cart[index];

    return Dismissible(
      key: ValueKey(
        '${item.food.id}_$index',
      ),

      direction:
          DismissDirection.endToStart,

      background: Container(
        margin:
            const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius:
              BorderRadius.circular(18),
        ),
        alignment:
            Alignment.centerRight,
        padding:
            const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),

      onDismissed: (_) {
        removeItem(index);
      },

      child: Container(
        margin:
            const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(14),
              child: Image.network(
                item.food.imageUrl,
                width: 78,
                height: 78,
                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    width: 78,
                    height: 78,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.fastfood,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '\$${item.food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _smallQuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          decreaseQuantity(index);
                        },
                      ),

                      SizedBox(
                        width: 35,
                        child: Center(
                          child: Text(
                            '${item.quantity}',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      _smallQuantityButton(
                        icon: Icons.add,
                        onTap: () {
                          increaseQuantity(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    removeItem(index);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 21,
                  ),
                  color: Colors.grey,
                ),

                const SizedBox(height: 5),

                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0EC),
          borderRadius:
              BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            color: AppColors.secondary,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Free delivery on orders over \$25',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (subtotal >= 25)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _summaryRow(
            'Subtotal',
            '\$${subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Delivery fee',
            deliveryFee == 0
                ? 'FREE'
                : '\$${deliveryFee.toStringAsFixed(2)}',
            valueColor: deliveryFee == 0
                ? Colors.green
                : AppColors.text,
          ),

          if (discount > 0) ...[
            const SizedBox(height: 12),

            _summaryRow(
              'Discount',
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
          ],

          const Padding(
            padding:
                EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
          ),

          _summaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal
                ? AppColors.text
                : AppColors.mutedText,
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color:
                valueColor ?? AppColors.text,
            fontSize: isTotal ? 19 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content:
                      Text('Checkout coming next!'),
                  behavior:
                      SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(17),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}