import 'package:flutter_test/flutter_test.dart';

import 'package:food_app/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());

    expect(find.text('Search for food...'), findsOneWidget);
    expect(find.text('Popular Near You'), findsOneWidget);
  });
}