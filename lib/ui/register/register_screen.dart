import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/utils/data_validator.dart';
import 'package:evently_app/data/firebase_auth_service.dart';
import 'package:evently_app/ui/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = "/registerScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Form(
              key: formKey,
              child: ListView(
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
                    localizations.createYourAccount,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  TextFormField(
                    controller: nameController,
                    validator: (value) =>
                        DataValidator.validateName(value, localizations),
                    autovalidateMode: .onUserInteraction,
                    decoration: InputDecoration(
                      hintText: localizations.enterYourName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        DataValidator.validateEmail(value, localizations),
                    autovalidateMode: .onUserInteraction,

                    decoration: InputDecoration(
                      hintText: localizations.enterYourEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    validator: (value) =>
                        DataValidator.validatePassword(value, localizations),
                    autovalidateMode: .onUserInteraction,

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
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) => DataValidator.validateConfirmPassword(
                      value,
                      passwordController.text,
                      localizations,
                    ),
                    autovalidateMode: .onUserInteraction,
                    obscureText: isConfirmPasswordObscure,
                    decoration: InputDecoration(
                      hintText: localizations.confirmYourPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordObscure =
                                !isConfirmPasswordObscure;
                          });
                        },
                      ),
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

                      FirebaseAuthService authService = FirebaseAuthService();
                      var user = await authService
                          .createAccountWithEmailAndPassword(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                          );

                      if (!mounted) return;

                      setState(() {
                        isLoading = false;
                      });

                      if (user != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
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
                        : Text(localizations.register),
                  ),

                  const SizedBox(height: 52),

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
                                  LoginScreen.routeName,
                                );
                              },
                              child: Text(
                                localizations.login,
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

                  const SizedBox(height: 24),

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
                        Text(localizations.signUpWithGoogle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
