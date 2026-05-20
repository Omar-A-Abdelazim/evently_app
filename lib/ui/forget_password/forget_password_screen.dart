import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/data_validator.dart';
import 'package:evently_app/data/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = "/forgetPasswordScreen";

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.forgotPassword)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Form(
            key: formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  provider.isDark
                      ? "assets/images/dark/Password.png"
                      : "assets/images/light/Password.png",
                  height: 220,
                ),
                const SizedBox(height: 40),

                Text(
                  localizations.forgotPassword,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      DataValidator.validateEmail(value, localizations),
                  decoration: InputDecoration(
                    hintText: localizations.enterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 40),

                FilledButton(
                  onPressed: () async {
                    if (isLoading) return;
                    if (formKey.currentState?.validate() == false) return;

                    setState(() => isLoading = true);

                    try {
                      await FirebaseAuthService().forgetPassword(
                        emailController.text.trim(),
                      );

                      if (!mounted) return;
                      setState(() => isLoading = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Reset password email sent" /*localizations.resetPasswordEmailSent*/,
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      setState(() => isLoading = false);

                      String errorMessage = localizations.somethingWentWrong;
                      if (e is FirebaseAuthException &&
                          e.code == 'user-not-found') {
                        errorMessage = localizations.userNotFound;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMessage)));
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.surface,
                        )
                      : Text("Reset Password" /*localizations.resetPassword*/),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
