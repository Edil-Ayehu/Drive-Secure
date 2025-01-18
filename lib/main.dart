import 'package:drive_secure/common/services/firebase_service.dart';
import 'package:drive_secure/common/services/preferences_service.dart';
import 'package:drive_secure/common/utils/app_theme.dart';
import 'package:drive_secure/firebase_options.dart';
import 'package:drive_secure/view/bloc/vehicle_bloc.dart';
import 'package:drive_secure/view/dashboard_screen.dart';
import 'package:drive_secure/view/home_screen.dart';
import 'package:drive_secure/view/login_screen.dart';
import 'package:drive_secure/view/onboarding_screen.dart';
import 'package:drive_secure/view/signup_screen.dart';
import 'package:drive_secure/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VehicleBloc(FirebaseService())..add(LoadVehicles()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Drive Secure',
        themeMode: _themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/dashboard': (context) => HomeScreen(onThemeToggle: toggleTheme),
        },
      ),
    );
  }
}
