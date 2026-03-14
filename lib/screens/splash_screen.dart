import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: const Icon(
                Icons.waves,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              child: Text(
                'SEAFOOD FRESH',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            FadeIn(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                'Premium Catch. Delivered Daily.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
