import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/ui/app_setup/app_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppSetupScreen.routeName);
    });
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Row(),
          Expanded(
            child: Image.asset(
              provider.isDark
                  ? "assets/images/logo_dark.png"
                  : "assets/images/logo_light.png",
              width: width * 0.85,
            ),
          ),
          Image.asset(
            provider.isDark
                ? "assets/images/branding_dark.png"
                : "assets/images/branding_light.png",
            width: width * 0.6,
          ),
        ],
      ),
    );
  }
}
