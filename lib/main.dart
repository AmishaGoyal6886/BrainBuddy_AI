import 'package:flutter/material.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/continue_screen.dart';
// later we will add:
// import 'screens/onboarding_screen.dart';
// import 'screens/home_screen.dart';

void main() {
  runApp(const BrainBuddyApp());
}

class BrainBuddyApp extends StatelessWidget {
  const BrainBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainBuddy AI',

      // Initial screen
      initialRoute: '/',

      // App routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/continue': (context) => const ContinueScreen(),

        // next steps (we will build later)
        // '/onboarding': (context) => const OnboardingScreen(),
        // '/home': (context) => const HomeScreen(),
      },
    );
  }
}
