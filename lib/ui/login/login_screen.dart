import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/data_validator.dart';
import 'package:evently_app/data/firebase/firebase_auth_service.dart';
import 'package:evently_app/ui/home/home_screen.dart';
import 'package:evently_app/ui/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordObscure = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppConfigProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Form(
            key: formKey,
            child: ListView(
              // ← أهم تعديل
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    theme.brightness == Brightness.dark
                        ? "assets/images/logo_dark.png"
                        : "assets/images/logo_light.png",
                    width: 180,
                  ),
                ),
                const SizedBox(height: 50),

                Text(
                  localizations.dontHaveAnAccount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: emailController,
                  validator: (value) =>
                      DataValidator.validateEmail(value, localizations),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: localizations.enterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  validator: (value) =>
                      DataValidator.validatePassword(value, localizations),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordObscure,
                  decoration: InputDecoration(
                    hintText: localizations.enterYourPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscure = !isPasswordObscure;
                        });
                      },
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(localizations.forgotPassword),
                  ),
                ),

                const SizedBox(height: 40),

                FilledButton(
                  onPressed: () async {
                    if (isLoading) return;
                    if (formKey.currentState?.validate() == false) return;

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      FirebaseAuthService authService = FirebaseAuthService();
                      var user = await authService.signInWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                      );

                      if (!mounted) return;

                      setState(() {
                        isLoading = false;
                      });

                      if (user != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          HomeScreen.routeName,
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (!mounted) return;
                      setState(() {
                        isLoading = false;
                      });

                      String errorMessage = localizations.somethingWentWrong;
                      if (e.code == 'user-not-found') {
                        errorMessage = localizations.userNotFound;
                      } else if (e.code == 'wrong-password') {
                        errorMessage = localizations.wrongPassword;
                      } else if (e.code == 'invalid-credential') {
                        errorMessage = localizations.invalidEmailOrPassword;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMessage)));
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.somethingWentWrong),
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.surface,
                        )
                      : Text(localizations.login),
                ),

                const SizedBox(height: 50),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(text: localizations.dontHaveAnAccount),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                RegisterScreen.routeName,
                              );
                            },
                            child: Text(
                              localizations.signUp,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Text(
                    localizations.or,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/google.png", width: 24),
                      const SizedBox(width: 12),
                      Text(localizations.loginWithGoogle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
