import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/theme/app_theme.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:evently_app/firebase_options.dart';
import 'package:evently_app/ui/app_setup/app_setup_screen.dart';
import 'package:evently_app/ui/events_management/edit_event_screen.dart';
import 'package:evently_app/ui/events_management/event_details_screen.dart';
import 'package:evently_app/ui/events_management/events_management_screen.dart';
import 'package:evently_app/ui/forget_password/forget_password_screen.dart';
import 'package:evently_app/ui/home/home_screen.dart';
import 'package:evently_app/ui/login/login_screen.dart';
import 'package:evently_app/ui/register/register_screen.dart';
import 'package:evently_app/ui/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          locale: Locale(provider.locale),
          title: 'Flutter Demo',
          themeMode: provider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (_) => const SplashScreen(),
            AppSetupScreen.routeName: (_) => const AppSetupScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
            RegisterScreen.routeName: (_) => const RegisterScreen(),
            HomeScreen.routeName: (_) => const HomeScreen(),
            EventsManagementScreen.routeName: (_) =>
                const EventsManagementScreen(),
            ForgetPasswordScreen.routeName: (_) => const ForgetPasswordScreen(),
            EventDetailsScreen.routeName: (context) {
              final event = ModalRoute.of(context)!.settings.arguments as Event;
              return EventDetailsScreen(event: event);
            },
            EditEventScreen.routeName: (context) {
              final event = ModalRoute.of(context)!.settings.arguments as Event;
              return EditEventScreen(event: event);
            },
          },
        ),
      ),
    );
  }
}
