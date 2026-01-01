# Mehfilista

A Flutter mobile application for a vendor/service marketplace platform, connecting users with service providers for events and gatherings.

## Project Overview

**Mehfilista** (from "mehfil" - Urdu/Hindi for gathering/event) is a marketplace app that allows users to discover vendors, make inquiries, and leave reviews. Vendors can create profiles, manage portfolios, and respond to customer inquiries.

## Tech Stack

- **Framework**: Flutter (Dart SDK ^3.9.2)
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: flutter_secure_storage
- **UI**: flutter_screenutil, google_fonts, flutter_svg, lottie
- **Localization**: flutter_localizations (English & French)

## Backend Configuration

**Live Server**: `http://20.83.180.133:9000`

API configuration files:
- [lib/utils/constants/api_constants.dart](lib/utils/constants/api_constants.dart) - Main API endpoints
- [lib/apis/api_config.dart](lib/apis/api_config.dart) - Base URL config

## Project Structure

```
lib/
├── apis/                    # API configuration
├── components/              # Reusable UI components
│   ├── custom_appbar.dart
│   ├── custom_button.dart
│   ├── custom_drawer.dart
│   ├── custom_navbar.dart
│   ├── custom_textfield.dart
│   └── ...
├── features/                # Feature modules
│   ├── auth/                # Authentication
│   │   ├── model/
│   │   ├── provider/
│   │   ├── views/
│   │   └── auth_services.dart
│   ├── home/                # Home screen
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── views/
│   ├── vendor/              # Vendor management
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── views/
│   ├── inquiry/             # Inquiry system
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── views/
│   ├── review/              # Review system
│   │   ├── models/
│   │   ├── providers/
│   │   └── services/
│   ├── profile/             # User profile
│   └── onboarding/          # Onboarding flow
├── l10n/                    # Localization files
├── routes/                  # App routing
├── services/                # Core services
│   ├── api_services.dart
│   ├── network_services.dart
│   ├── local_provider.dart
│   └── user_storage.dart
├── theme/                   # App theming
│   ├── theme.dart
│   ├── theme_provider.dart
│   └── widget_themes/
├── utils/                   # Utilities
│   ├── constants/
│   ├── exceptions/
│   ├── formatters/
│   └── helpers/
└── myapp.dart               # Main app widget
```

## Features

### Authentication
- User registration and login
- Email verification
- Password reset flow
- Secure token storage

### Home
- Vendor recommendations
- Categories browsing
- Location-based search
- Statistics dashboard

### Vendors
- Search and filter vendors
- Vendor detail pages
- Create/edit vendor profiles
- Portfolio management
- Vendor dashboard

### Inquiries
- Send inquiries to vendors
- View sent/received inquiries
- Respond to inquiries

### Reviews
- Leave reviews for vendors
- View vendor reviews

### Profile
- User profile management
- Role selection (user/vendor)
- Edit profile

## API Endpoints

All endpoints are prefixed with the base URL (`http://20.83.180.133:9000`):

### Auth
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `GET /auth/me` - Get current user
- `POST /auth/reset-password` - Reset password

### Home
- `GET /home/recommendations` - Get recommendations
- `GET /home/categories` - Get categories
- `GET /home/locations` - Get locations

### Vendors
- `GET /vendors/search` - Search vendors
- `GET /vendors/:id` - Get vendor details
- `POST /vendors` - Create vendor
- `GET /vendors/me` - Get current user's vendor
- `PUT /vendors/:id` - Update vendor
- `POST /vendors/:id/portfolio` - Upload portfolio

### Inquiries
- `POST /inquiries` - Send inquiry
- `GET /inquiries/me` - Get user's inquiries
- `GET /inquiries/vendor/me` - Get vendor's inquiries
- `GET /inquiries/:id` - Get inquiry details
- `PUT /inquiries/:id` - Respond to inquiry

### Reviews
- `POST /reviews` - Leave review
- `GET /reviews/vendor/:vendorId` - Get vendor reviews

## Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Generate launcher icons
flutter pub run flutter_launcher_icons

# Clean build
flutter clean && flutter pub get
```

## Theming

The app supports both light and dark themes via `ThemeProvider`. Theme configuration is in [lib/theme/](lib/theme/).

## Localization

Supports English and French. Localization files are in [lib/l10n/](lib/l10n/).

To add new translations:
1. Add strings to `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb`
2. Run `flutter gen-l10n`

## Environment

- Design size: 393x852 (iPhone 14 Pro reference)
- Min Android SDK: 28
