# Drive Secure - Vehicle Monitoring Application

A modern Flutter application for monitoring and managing vehicle fleets with real-time tracking, status updates, and maintenance scheduling.

## Features

- 🚗 Vehicle Fleet Management
- 📊 Real-time Monitoring
- 🔋 Battery & Fuel Level Tracking
- 📍 Location Tracking
- 🔐 Secure Authentication
- 🌓 Dark/Light Theme Support
- 📱 Responsive Design

## Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Git](https://git-scm.com/downloads)

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yourusername/drive-secure.git
```
2. Navigate to the project directory:
```bash
cd drive-secure
```
3. Install dependencies:
```bash
flutter pub get
```

3. Setup Firebase:
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication and Firestore
   - Copy `lib/firebase_options.template.dart` to `lib/firebase_options.dart`
   - Update Firebase configuration values

## Firebase Configuration

1. In Firebase Console:
   - Go to Project settings > General > Your apps
   - Click "Add app" and select Flutter
   - Follow the setup instructions
   - Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

2. Configure Firebase options:
   - Copy template: `cp lib/firebase_options.template.dart lib/firebase_options.dart`
   - Replace placeholder values with your Firebase configuration

## Project Structure


lib/
├── common/
│   ├── services/          # Authentication and API services

│   └── utils/            # Utility functions and constants
├── model/
│   └── vehicle.dart      # Vehicle data model
├── view/
│   ├── bloc/            # State management
│   ├── widgets/         # Reusable UI components
│   └── screens/         # Application screens
└── main.dart            # Application entry point
```

## Features in Detail

### Authentication
- Email/Password Sign Up
- Secure Login
- Password Reset Functionality
- Session Management

### Vehicle Management
- Add/Edit Vehicles
- Real-time Status Updates
- Fuel Level Monitoring
- Battery Level Tracking
- Location History

### User Interface
- Material Design
- Dark/Light Theme
- Responsive Layout
- Custom Animations
- Loading States

## Running the App

1. Start an emulator or connect a physical device

2. Run the app:
```bash
flutter run
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

Run tests using:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Security

- Never commit `firebase_options.dart` to version control
- Keep API keys and secrets in environment variables
- Follow Flutter security best practices

## Troubleshooting

Common issues and solutions:

1. Firebase Configuration Issues:
   - Verify `firebase_options.dart` is properly configured
   - Ensure Firebase services are enabled in console

2. Build Errors:
   - Run `flutter clean`
   - Delete build folder and rebuild

3. Dependencies Issues:
   - Update Flutter: `flutter upgrade`
   - Clean pub cache: `flutter pub cache clean`