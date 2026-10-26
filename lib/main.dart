import 'package:assignment_7/l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:assignment_7/ui/search/search_screen.dart';
import 'package:assignment_7/ui/home/home_screen.dart';
import 'package:assignment_7/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_config_provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppConfigProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: provider.themeMode,
      theme: AppTheme(LightColors()).theme,
      darkTheme: AppTheme(DarkColors()).theme,
      routes: {
        SearchScreen.routeName: (_) => const SearchScreen(),
        SplashScreen.routeName: (_) => SplashScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
