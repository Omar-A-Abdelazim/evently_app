import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/theme/app_theme.dart';
import 'package:evently_app/ui/app_setup/app_setup_screen.dart';
import 'package:evently_app/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppConfigProvider(),
      child: Consumer<AppConfigProvider>(
        builder: (context, provider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(provider.Local),
          title: 'Flutter Demo',
          themeMode: provider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (_) => const SplashScreen(),
            AppSetupScreen.routeName: (_) => const AppSetupScreen(),
          },
        ),
      ),
    );
  }
}
