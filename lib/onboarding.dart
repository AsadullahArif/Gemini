// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:chat_app/myHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);
   Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Column(
              children: [
                Text(
                  "You'r AI Assistant",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  'Using this software, you can ask you questions and receive articles using artificial intelligence assistant',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Image.asset('assets/onboarding.png'),
            const SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                _completeOnboarding(context);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => const MyHomePage()),
                //     (route) => false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 80),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Continue',style: TextStyle(color: Colors.white,fontSize: 24),),
                      SizedBox(
                        height: 8,
                      ),
                      Icon(Icons.arrow_forward)
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
