import 'dart:developer';
import 'dart:math' hide log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ss_chat/api/apis.dart';
// import 'package:http/http.dart' as http;
import 'package:ss_chat/helper/dialogs.dart';
import 'package:ss_chat/screens/home_screen.dart';

/// --------------------- Login Screen ---------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF69BFE2),

      /// --------------------- App Bar ---------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF69BFE2),
        title: Row(
          children: [
            Image.asset('images/icon.png', height: 30),
            const SizedBox(width: 10),
            const Text('helloYou!', style: TextStyle(color: Colors.black)),
          ],
        ),
        centerTitle: false,
        // elevation: 3,
      ),

      /// --------------------- Body ---------------------
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --------------------- Welcome Card ---------------------
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
              ),
              child: Container(
                width: double.infinity,
                // height: MediaQuery.of(context).size.height * 0.2,
                color: const Color(0xFF69BFE2),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/icon.png', height: 100),
                    const Text(
                      "Welcome to \n helloYou!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),

            /// --------------------- Sign In Button ---------------------
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: min(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width) * 0.9,
                height: max(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF97d68f),
                  ),
                  // style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF69BFE2)),
                  onPressed: _handleLoginBtnClick,
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------- Login Logic ---------------------
  void _handleLoginBtnClick() {
    // Show progress bar
    Dialogs.showprogressbar(context);

    signInWithGoogle().then((user) async {
      // Hide progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
          log('\nOLD USER');
        } else {
          await APIs.createUser().then(
            (onValue) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              ),
            },
          );
          log('\nNEW USER');
        }
      } else {
        log('\nLogin canceled by user');
      }
    });
  }

  /// --------------------- Google Sign-In ---------------------
  Future<UserCredential?> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize();

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\nCANCELLED LOGIN');
      Dialogs.showSnackbar(context, 'Something went wrong! Try again...');
      return null;
    }
  }

  /// --------------------- Internet Check (Commented Out) ---------------------
  // Future<bool> checkinternet() async {
  //   try {
  //     await InternetAddress.lookup('www.google.com');
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<bool> checkinternet() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('https://www.google.com'))
  //         .timeout(const Duration(seconds: 5));
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
