import 'package:flutter_test/flutter_test.dart';
import 'package:car_diary/main.dart';

void main() {
  testWidgets('Проверка за заглавие на началния екран', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Авто Дневник'), findsOneWidget);
  });
}
