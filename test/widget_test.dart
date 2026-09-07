// 冒烟测试：当前 App 根组件还是脚手架模板 MyApp（lib/main.dart，计数器 demo）。
// 等真实根组件 TaoyueEduApp（lib/app.dart）和底部导航页面建好后，
// 再替换为断言「首页 / 我的」Tab 文案的冒烟测试。
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taoyue_edu/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
