import 'dart:async';

import 'package:flutter/material.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({required this.nextRoute, super.key});

  static const routeName = '/launch-splash';

  final String nextRoute;

  @override
  State<LaunchSplashScreen> createState() => _LaunchSplashScreenState();
}

class _LaunchSplashScreenState extends State<LaunchSplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/branding/opening_splash.jpeg',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
