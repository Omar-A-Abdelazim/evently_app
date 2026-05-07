# Flutter Localization Translation Rules

To ensure a smooth and consistent multi-language experience across the application, please adhere strictly to the following localization rules:

## 1. No Hard-Coded Strings
- **Rule**: Never use raw string literals (e.g., `'Hello World'`, `"Submit"`) for user-facing UI text within Dart code (`.dart` files).
- **Reason**: Hard-coded strings bypass the localization system, leading to a fragmented user experience where only part of the app is translated.

## 2. Use ARB Files for All Translations
- **Rule**: Any user-facing string must be added to the Application Resource Bundle (`.arb`) files.
- **Requirement**: Whenever a new string is introduced, it must be added and translated for both English (`en`) and Arabic (`ar`).
- **Files**:
  - `lib/l10n/app_en.arb` (English)
  - `lib/l10n/app_ar.arb` (Arabic)
- **Format Example**:
  ```json
  // In app_en.arb
  {
    "helloWorld": "Hello World!",
    "@helloWorld": {
      "description": "Greeting text"
    }
  }
  ```
  ```json
  // In app_ar.arb
  {
    "helloWorld": "مرحباً بالعالم!"
  }
  ```

## 3. Access Strings via AppLocalizations
- **Rule**: Always use the generated `AppLocalizations` class to access localized strings in your Flutter widgets.
- **Usage Example**:
  ```dart
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';

  // ... inside your widget's build method:
  Text(AppLocalizations.of(context)!.helloWorld)
  ```
- **Reason**: This ensures that the app automatically switches text when the user changes their device language or in-app language preference, guaranteeing compile-time safety and autocompletion for your translation keys.
