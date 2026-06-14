# Dompetin - Flutter GetX App

Personal finance manager app built with Flutter + GetX.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── routes/
│   └── app_routes.dart               # Named routes
├── theme/
│   └── app_theme.dart                # Colors, text styles, input decorations
├── controllers/
│   ├── splash_controller.dart        # Auto-navigate after 3s
│   ├── onboarding_controller.dart    # Page swipe + slide data
│   ├── login_controller.dart         # Login form logic
│   └── register_controller.dart     # Register form logic
├── views/
│   ├── splash/splash_screen.dart    # Loading/splash screen
│   ├── onboarding/onboarding_screen.dart  # 3-slide onboarding
│   ├── login/login_screen.dart      # Login form
│   └── register/register_screen.dart # Register form
└── widgets/
    ├── dompetin_logo.dart            # Reusable logo widget
    ├── buttons.dart                  # PrimaryButton, OutlineButton
    └── google_button.dart            # GoogleSignInButton, DividerWithText
```

---

## 🚀 Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Run the app
```bash
flutter run
```

---

## 📦 Dependencies

| Package | Version | Usage |
|---|---|---|
| `get` | ^4.6.6 | State management + navigation |
| `google_fonts` | ^6.1.0 | Poppins font |
| `smooth_page_indicator` | ^1.1.0 | Onboarding dots |
| `flutter_svg` | ^2.0.9 | SVG support |
| `local_auth` | ^2.1.8 | Biometric login (future) |
| `shared_preferences` | ^2.2.2 | Persist login state |

---

## 🎨 Design Tokens

| Token | Value |
|---|---|
| Primary Blue | `#1A6BFF` |
| Deep Blue | `#0A4FD8` |
| Accent Yellow | `#FFCC00` |
| Text Dark | `#1A1F36` |
| Text Grey | `#8F95B2` |
| Font | Poppins (Google Fonts) |

---

## 📱 Screens

| Screen | Route | Description |
|---|---|---|
| Splash | `/` | 3-second loading with animated card |
| Onboarding | `/onboarding` | 3-slide swipeable intro |
| Login | `/login` | Email + password with validation |
| Register | `/register` | Name, email, password, confirm password |

---

## 🔧 Replacing Illustrations

The onboarding illustrations currently use emoji placeholders.  
To swap in real 3D illustrations (like in the Figma):

1. Add your image assets to `assets/images/`
2. Update `pubspec.yaml` asset paths if needed
3. Replace `_Slide1Illustration`, `_Slide2Illustration`, `_Slide3Illustration` widgets in `onboarding_screen.dart` with:

```dart
Image.asset('assets/images/onboarding_1.png', height: 200)
```

Or use **Lottie** animations:
```bash
flutter pub add lottie
```
```dart
Lottie.asset('assets/animations/finance.json')
```

---


## 🔐 Forgot Password Flow

| Step | Screen | Route Trigger |
|---|---|---|
| 1 | Input Email | Login → Lupa Kata Sandi? |
| 2 | Check Email (OTP) | After sendEmail() |
| 3 | Verify Confirm | After verifyOtp() |
| 4 | Reset Password | After verify confirm |

All 4 steps are managed inside a single `ForgotPasswordScreen` using `currentStep.obs` — no extra routes needed. Navigation between steps is animated with `AnimatedSwitcher`.

## ✅ TODOs / Next Steps

- [ ] Connect real auth API (email + Google)
- [x] Forgot password flow (4 steps)
- [x] OTP input with auto-focus
- [ ] Add `local_auth` biometric on login
- [ ] Store JWT in `shared_preferences`
- [ ] Add home dashboard screen
- [ ] Add transaction list screen
- [ ] Wire up real 3D illustrations from Figma
