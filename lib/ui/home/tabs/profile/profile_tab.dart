import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/date_extension.dart';
import 'package:evently_app/core/utils/dialog_utils.dart';
import 'package:evently_app/ui/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/core/l10n/app_localizations.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppConfigProvider>(context);
    final theme = Theme.of(context);
    final isDark = provider.isDark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.asset('assets/images/Profile.png'),
              ),
              const SizedBox(height: 24),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ??
                    AppLocalizations.of(context)!.noNameFound,
                style: theme.textTheme.titleSmall,
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? AppLocalizations.of(context)!.noEmailFound,
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 32),

              _buildToggleContainer(
                context: context,
                title: AppLocalizations.of(context)!.theme,
                toggle: AnimatedToggleSwitch<bool>.dual(
                  current: provider.isDark,
                  first: false,
                  second: true,
                  spacing: 4.0,
                  animationDuration: const Duration(milliseconds: 350),
                  style: ToggleStyle(
                    borderColor: Colors.transparent,
                    indicatorColor: theme.colorScheme.primary,
                    backgroundColor: isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFE0E0E0),
                  ),
                  iconBuilder: (value) => Icon(
                    value ? Icons.dark_mode : Icons.light_mode,
                    size: 20,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  onChanged: (value) => provider.toggleTheme(),
                ),
              ),

              const SizedBox(height: 16),

              _buildToggleContainer(
                context: context,
                title: AppLocalizations.of(context)!.language,
                toggle: AnimatedToggleSwitch<bool>.dual(
                  current: provider.isEnglish,
                  first: false,
                  second: true,
                  spacing: 4.0,
                  animationDuration: const Duration(milliseconds: 350),
                  style: ToggleStyle(
                    borderColor: Colors.transparent,
                    indicatorColor: theme.colorScheme.primary,
                    backgroundColor: isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFE0E0E0),
                  ),
                  iconBuilder: (value) => Text(
                    value ? "EN" : "AR",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  onChanged: (value) => provider.toggleLanguage(),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withAlpha(20),
                  ),
                ),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.logout, style: theme.textTheme.bodyLarge),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DialogUtils.buildDialog(
                          context,
                          title: AppLocalizations.of(context)!.logout,
                          content: AppLocalizations.of(context)!.areYouSureYouWantToLogout,
                          negActionText: AppLocalizations.of(context)!.ok,
                          posActionText: AppLocalizations.of(context)!.cancel,
                          negAction: () async {
                            Navigator.pushReplacementNamed(
                              context,
                              LoginScreen.routeName,
                            );
                            await FirebaseAuth.instance.signOut();
                          },
                        );
                      },
                      child: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleContainer({
    required BuildContext context,
    required String title,
    required Widget toggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          SizedBox(width: 110, child: toggle),
        ],
      ),
    );
  }
}
