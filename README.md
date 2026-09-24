# FoodoraX

A food delivery app UI built with Flutter and Material 3.
This is a front-end / UX showcase: static data, no backend, no authentication.

## Features

- Home with promo banner, category filter, popular dishes and offers
- Live search by name or category
- Favorites (heart toggle, dedicated screen with empty state)
- Explore screen with category filter
- Dish details with hero animation, quantity selector and add to cart
- Cart with quantity controls, delivery fee and discount logic, empty state
- Checkout flow: address, payment method, order summary, success screen
- Notifications, profile, address picker
- Shimmer skeleton loading and staggered fade-in animations

## Tech

- Flutter (Material 3)
- No external dependencies beyond `cupertino_icons`
- State handled with `setState` and callbacks (no state management package)

## Project structure

lib/
├── main.dart
├── data/          static food data
├── models/        FoodItem, CartItem
├── theme/         colors and theme
├── utils/         category icons, ingredients
├── widgets/       FoodCard, CategoryChip, SectionTitle, skeleton, FadeInUp
└── screens/       home, explore, favorites, details, cart, checkout, profile...

## Run locally

flutter pub get
flutter run -d chrome

## Build

flutter build apk --release
flutter build web --release

## Screenshots

| Home | Details | Cart |
|------|---------|------|
| ![Home](screenshots/home.png) | ![Details](screenshots/details.png) | ![Cart](screenshots/cart.png) |

## Notes

Images are loaded from Unsplash. All data is hard-coded for demo purposes.