// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _currentOpacity = 0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final value = GlobalKey<FormState>();

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

  bool _isTap = true;

  final _formKey = GlobalKey<FormState>();

  void signUserIn() async {
    Dialogs.showProgressBar(context);

    try {
      await APISystem.auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Email doesn't exist in the authentication system
        Dialogs.showSnackBar(context, 'Invalid Email');
      } else if (e.code == 'wrong-password') {
        // Incorrect password
        Dialogs.showSnackBar(context, 'Incorrect Password');
      } else {
        // Handle other Firebase Auth exceptions if needed
        Dialogs.showSnackBar(context, 'Authentication Failed: ${e.message}');
      }
    } catch (e) {
      // Handle other exceptions that might occur during the authentication process
      Dialogs.showSnackBar(context, 'Authentication Failed: $e');
    }

    Navigator.pop(context); // Dismiss progress bar
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: AnimatedOpacity(
                          opacity: _currentOpacity,
                          duration: const Duration(seconds: 2),
                          child: Image.asset(
                            'images/icon.png',
                            width: mq.width * 0.40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Welcome to Chatifly',
                        style: TextStyle(
                          // color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: emailController,
                                maxLength: 50,
                                validator: (value) {
                                  // RegExp username = RegExp(r"^(?=.*[A-Za-z]).{3,}");
                                  RegExp email = RegExp(
                                      r"^(?=.*[A-Za-z]).{3,}.[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z].{1,2}$");
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your email';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: "Enter your email",
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                obscureText: _isTap,
                                controller: passwordController,
                                validator: (value) {
                                  RegExp password = RegExp(
                                      r'^(?=.*?[A-Za-z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your password';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  suffixIcon: _isTap == true
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isTap = false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.grey[400],
                                          ))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isTap = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.visibility_off,
                                            color: Colors.grey[400],
                                          )),
                                  hintText: "Password",
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(15)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          return signUserIn();
                                        }
                                      },
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Forgot your login details ? ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Forgot your password.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                )
                              ],
                            ),
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'Forgot your login details? ',
                            //     style: TextStyle(
                            //       color: Theme.of(context).colorScheme.primary,
                            //       fontSize: 12,
                            //     ),
                            //     children: [
                            //       TextSpan(
                            //         onEnter: (event) {},
                            //         text: 'Forgot your password.',
                            //         style: TextStyle(
                            //             decoration: TextDecoration.underline,
                            //             fontWeight: FontWeight.bold,
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .primary),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ]),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 55.0, right: 35, left: 35),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('OR'),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 15),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17)),
                        ),
                      ),
                      onPressed: () {
                        _googleSignin();
                      },
                      child: Image.asset(
                        'images/google.png',
                        width: mq.width * 0.07,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member ?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mess_app/api/api_system.dart';
// import 'package:mess_app/helper/dialog.dart';
// import 'package:mess_app/main.dart';
// import 'package:flutter/material.dart';
// import 'package:mess_app/screens/home_screen.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   double _currentOpacity = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         _currentOpacity = 1;
//       });
//     });
//   }

//   _googleSignin() {
//     Dialogs.showProgressBar(context);
//     _signInWithGoogle().then((user) async {
//       Navigator.pop(context);
//       if (user != null) {
//         print('\n user: ${user.user}');
//         print('\n userAdditionalDetail: ${user.additionalUserInfo}');

//         if (await (APISystem.isUserExist())) {

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const HomeScreen(),
//             ),
//           );
//         } else {
//           await APISystem.userCreate()
//               .then((value) => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const HomeScreen(),
//                     ),
//                   ));
//         }
//       }
//     });
//   }

//   Future<UserCredential?> _signInWithGoogle() async {
//     // Trigger the authentication flow
//     try {
//       await InternetAddress.lookup('google.com');
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       // Once signed in, return the UserCredential
//       return await APISystem.auth.signInWithCredential(credential);
//     } catch (e) {
//       print('_signInWithGoogle : $e');
//       Dialogs.showSnackBar(
//         context,
//         'Something went wrong ( Check your internet connection! )',
//       );
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     mq = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         body: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(top: mq.height * 0.1),
//                 child: const Text(
//                   'Welcome to Chatifly',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: mq.height * 0.15,
//               left: mq.width * .05,
//               width: mq.width * .9,
//               height: mq.height * .9,
//               child: Center(
//                 child: AnimatedOpacity(
//                   opacity: _currentOpacity,
//                   duration: const Duration(seconds: 2),
//                   child: Image.asset(
//                     'images/icon.png',
//                     width: mq.width * 0.50,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: mq.height * 0.20),
//                 child: ElevatedButton.icon(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                         Theme.of(context).colorScheme.secondary),
//                     padding: MaterialStateProperty.all(
//                       const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
//                     ),
//                     shape: MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(17)),
//                     ),
//                   ),
//                   onPressed: () {
//                     _googleSignin();
//                   },
//                   icon: Image.asset(
//                     'images/google.png',
//                     width: mq.width * 0.07,
//                   ),
//                   label: Text('Login with Google',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Theme.of(context).colorScheme.primary,
//                           fontSize: 19)),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
