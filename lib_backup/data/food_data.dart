import '../models/food_item.dart';

final List<FoodItem> foodItems = [
  FoodItem(
    id: '1',
    name: 'Supreme Pan Pizza',
    description: 'Loaded with vegetables, mushrooms and mozzarella.',
    price: 12.49,
    imageUrl:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    category: 'Pizza',
    rating: 4.9,
    reviews: 128,
    isPopular: true,
  ),

  FoodItem(
    id: '2',
    name: 'Cheese Lovers',
    description: 'Extra cheese with a delicious crispy crust.',
    price: 11.49,
    imageUrl:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    category: 'Pizza',
    rating: 4.8,
    reviews: 96,
    isPopular: true,
  ),

  FoodItem(
    id: '3',
    name: 'BBQ Chicken Pizza',
    description: 'Tender chicken with smoky BBQ sauce.',
    price: 12.99,
    imageUrl:
        'https://images.unsplash.com/photo-1594007654729-407eedc4be65',
    category: 'Pizza',
    rating: 4.7,
    reviews: 87,
    isPopular: true,
  ),

  FoodItem(
    id: '4',
    name: 'Garlic Bread',
    description: 'Crispy, buttery and delicious garlic bread.',
    price: 4.99,
    imageUrl:
        'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c',
    category: 'Sides',
    rating: 4.6,
    reviews: 74,
  ),

  FoodItem(
    id: '5',
    name: 'Chicken Wings',
    description: 'Crispy spicy grilled chicken wings.',
    price: 7.49,
    imageUrl:
        'https://images.unsplash.com/photo-1608039755401-742074f0548d',
    category: 'Sides',
    rating: 4.8,
    reviews: 115,
  ),

  FoodItem(
    id: '6',
    name: 'Coca Cola',
    description: 'Ice cold refreshing drink.',
    price: 2.49,
    imageUrl:
        'https://images.unsplash.com/photo-1554866585-cd94860890b7',
    category: 'Drinks',
    rating: 4.5,
    reviews: 62,
  ),

  FoodItem(
    id: '7',
    name: 'Fresh Orange Juice',
    description: 'Freshly squeezed orange juice.',
    price: 3.49,
    imageUrl:
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba',
    category: 'Drinks',
    rating: 4.9,
    reviews: 91,
  ),
];

const List<String> categories = [
  'All',
  'Pizza',
  'Burgers',
  'Sides',
  'Drinks',
  'Desserts',
];