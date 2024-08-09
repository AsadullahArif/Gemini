// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:chat_app/myHomePage.dart';
import 'package:chat_app/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardComplete = prefs.getBool('onboardingComplete')??false ;
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    if (onboardComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gpt-robot.png',
              // height: 100,
              // width: 100,
            ),
            // const SizedBox(height: 20),
            // const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
