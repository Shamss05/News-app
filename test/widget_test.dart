import 'package:flutter/services.dart';
import 'package:assignment_7/core/providers/app_config_provider.dart';
import 'package:assignment_7/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'Splash opens home and drawer changes theme and switches languages',
    (tester) async {
      // Load translation assets outside the test's fake clock.
      await tester.runAsync(() async {
        await rootBundle.loadString('lib/l10n/app_en.arb');
        await rootBundle.loadString('lib/l10n/app_ar.arb');
      });
      final config = AppConfigProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(value: config, child: const MyApp()),
      );
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Language'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<ThemeMode>));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Light').last);
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(config.themeMode, ThemeMode.light);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.byType(DropdownButton<String>));
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arabic').last);
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(config.locale.languageCode, 'ar');
      expect(find.text('اللغة'), findsOneWidget);
      expect(find.text('تطبيق الأخبار'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(DropdownButton<String>))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('الإنجليزية').last);
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(config.locale.languageCode, 'en');
      expect(find.text('Language'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(DropdownButton<String>))),
        TextDirection.ltr,
      );
      expect(config.themeMode, ThemeMode.light);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      config.dispose();
    },
  );
}
