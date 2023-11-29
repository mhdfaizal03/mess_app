import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _currentOpacity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _currentOpacity = 1;
      });
    });
  }

  _googleSignin() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        print('\n user: ${user.user}');
        print('\n userAdditionalDetail: ${user.additionalUserInfo}');

        if (await (APISystem.isUserExist())) {
        
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        } else {
          await APISystem.userCreate()
              .then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  ));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APISystem.auth.signInWithCredential(credential);
    } catch (e) {
      print('_signInWithGoogle : $e');
      Dialogs.showSnackBar(
        context,
        'Something went wrong ( Check your internet connection! )',
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: mq.height * 0.1),
                child: const Text(
                  'Welcome to Chatifly',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .9,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _currentOpacity,
                  duration: const Duration(seconds: 2),
                  child: Image.asset(
                    'images/icon.png',
                    width: mq.width * 0.50,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: mq.height * 0.20),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17)),
                    ),
                  ),
                  onPressed: () {
                    _googleSignin();
                  },
                  icon: Image.asset(
                    'images/google.png',
                    width: mq.width * 0.07,
                  ),
                  label: Text('Login with Google',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 19)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
