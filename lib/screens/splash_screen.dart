import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/screens/authentication/auth_page.dart';
import 'package:mess_app/screens/authentication/login_page.dart';
import 'package:mess_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:mess_app/themes/light_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final double _currentOpacity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent));

      if (APISystem.auth.currentUser != null) {
        log('User : ${APISystem.auth.currentUser}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AuthPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            bottom: mq.height * 0.15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .7,
            child: Center(
              child: Image.asset(
                'images/icon.png',
                width: mq.width * 0.50,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: mq.height * 0.20),
              child: const Text(
                'MADE BY FAIZAL WITH ❤️',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
