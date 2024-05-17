import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb_wespend/auth/login.dart';
import 'package:tubes_ppb_wespend/home.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    // Delay the transition to the next page
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showLogin = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.yellow[600],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData) {
              return const Home();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 950),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _showLogin
                    ? const Login()
                    : Container(
                        key: const ValueKey('intro'),
                        color: Colors.yellow[600],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "WSPend",
                                style: GoogleFonts.vampiroOne(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Hello WSpend friends! Welcome to the WSpend application where your journey to become financially wise begins!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
