import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycle_gang/app/app.dart';
import 'package:recycle_gang/app/router.dart';
import 'package:recycle_gang/core/providers.dart';

void main() {
  testWidgets('home opens a reservation, saves items and shows review', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    router.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesProvider.overrideWithValue(prefs)],
        child: const RecycleGangApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('資源に、\n次の出番を。'), findsOneWidget);
    await tester.tap(find.text('指定場所に持ち込む').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('回収品').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('金属・小物を増やす'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('この内容で保存'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('持込日時'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('00:00–24:00').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('予約内容を確認する'));
    await tester.pumpAndSettle();
    expect(find.text('テスト決済の合計'), findsOneWidget);
    await tester.tap(find.text('この内容で予約する'));
    await tester.pumpAndSettle();
    expect(find.text('予約を受け付けました'), findsOneWidget);
    await tester.tap(find.text('予約の詳細を見る'));
    await tester.pumpAndSettle();
    expect(find.text('入場QRコードを表示'), findsOneWidget);
    await tester.tap(find.text('入場QRコードを表示'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('モック入場受付を実行'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('モック入場受付を実行'));
    await tester.pumpAndSettle();
    expect(find.text('写真を選ぶ'), findsOneWidget);
    await tester.pumpWidget(const SizedBox()); // dispose polling timer
  });
}
