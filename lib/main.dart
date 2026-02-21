import 'package:flutter/material.dart';
import 'package:finito_app/data/service_locator.dart';
import 'package:finito_app/screens/splash/splash_screen.dart';
import 'package:finito_app/screens/auth/auth_check.dart';
import 'package:finito_app/screens/auth/login_screen.dart';
import 'package:finito_app/screens/home/home_screen.dart';

void main() {
  serviceLocator.setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finito App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10b981)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth-check': (context) => const AuthCheck(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
