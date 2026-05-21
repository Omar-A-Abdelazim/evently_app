# Evently App 🎉

A Flutter event management application with Firebase integration, supporting light/dark themes and Arabic/English localization.

---

## ✨ Features

### 🔐 Authentication
- Email & Password Sign In / Register
- Google Sign In
- Forgot Password (email reset link)
- Firebase Authentication integration

### 🎨 UI & Theming
- Light & Dark theme support
- Arabic & English localization
- App setup screen for language and theme selection
- Onboarding screens (3 pages)

### 📅 Event Management
- Create events with title, description, date, time, and category
- Edit existing events
- Delete events with confirmation dialog
- Real-time updates via Firebase Firestore
- Filter events by category

### ❤️ Favorites
- Add/remove events to favorites
- Dedicated favorites tab

### 👤 Profile
- User profile tab

---

## 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| Flutter | UI Framework |
| Firebase Auth | Authentication |
| Firebase Firestore | Database |
| Google Sign-In | OAuth Login |
| Provider | State Management |
| Intl | Localization & Date Formatting |

---

## 📁 Project Structure
lib/
├── core/
│   ├── l10n/              # Localization files
│   ├── provider/          # AppConfigProvider (theme & language)
│   ├── theme/             # AppTheme & AppColors
│   └── utils/             # Validators, Extensions, DialogUtils
├── data/
│   ├── firebase/          # FirebaseAuthService, FirebaseEventsDatabase, GoogleAuthService
│   └── models/            # Event, Category models
└── ui/
├── app_setup/         # Language & theme setup screen
├── onboarding/        # 3-page onboarding
├── login/             # Login screen
├── register/          # Register screen
├── forget_password/   # Forgot password screen
├── home/              # Home screen with 3 tabs
│   ├── tabs/
│   │   ├── home_tab/        # Events list with category filter
│   │   ├── favorite_tab/    # Favorite events
│   │   └── profile_tab/     # User profile
│   └── widgets/       # EventCard
└── events_management/ # Add, Edit, Details screens

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Firebase project configured
- `google-services.json` placed in `android/app/`

### Installation

```bash
git clone https://github.com/your-username/evently_app.git
cd evently_app
flutter pub get
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: latest
  firebase_auth: latest
  cloud_firestore: latest
  google_sign_in: ^6.2.1
  provider: latest
  intl: latest
```

---

## 🌍 Localization

The app supports:
- 🇺🇸 English
- 🇸🇦 Arabic

Language can be changed from the **App Setup Screen** or toggled from the **Home Screen**.

---

## 🎨 Theme

The app supports:
- ☀️ Light Mode
- 🌙 Dark Mode

Theme can be changed from the **App Setup Screen** or toggled from the **Home Screen**.

---

## 🔥 Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Email/Password** and **Google** sign-in methods
3. Create a **Firestore** database
4. Download `google-services.json` and place it in `android/app/`
5. Add your **SHA-1** key in Firebase project settings

---

## 📱 App Flow
