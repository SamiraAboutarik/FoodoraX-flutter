class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviews;
  final bool isPopular;
  final bool isFavorite;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.8,
    this.reviews = 100,
    this.isPopular = false,
    this.isFavorite = false,
  });
}