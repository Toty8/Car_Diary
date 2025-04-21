import 'package:flutter_test/flutter_test.dart';
import 'package:car_diary/main.dart';

void main() {
  testWidgets('Приложението стартира с екран за вход/регистрация', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Вход'), findsOneWidget);
    expect(find.text('Регистрация'), findsOneWidget);
    expect(find.text('Авто Дневник'), findsOneWidget);
  });
}
