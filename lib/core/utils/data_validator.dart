import 'package:evently_app/core/l10n/app_localizations.dart';

class DataValidator {
  static String? validateName(String? name, AppLocalizations localizations) {
    if (name == null || name.trim().isEmpty) {
      return localizations.nameCannotBeEmpty;
    }
    return null;
  }

  static String? validateEmail(String? email, AppLocalizations localizations) {
    if (email == null || email.trim().isEmpty) {
      return localizations.emailCannotBeEmpty;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(email)) {
      return localizations.invalidEmailFormat;
    }
    return null;
  }

  static String? validatePassword(
    String? password,
    AppLocalizations localizations,
  ) {
    if (password == null || password.isEmpty) {
      return localizations.passwordCannotBeEmpty;
    }
    if (password.length < 8) {
      return localizations.passwordTooShort;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? confirmPassword,
    String? password,
    AppLocalizations localizations,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return localizations.passwordCannotBeEmpty;
    }
    if (confirmPassword != password) {
      return localizations.passwordsDoNotMatch;
    }
    return null;
  }
}
