import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.yellow[600],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("WSPend",
                        style: GoogleFonts.vampiroOne(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                          ),
                        )),
                    SizedBox(height: 20),
                    Text(
                        "Hello WSpend friends! Welcome to the WSpend application where your journey to become financially wise begins!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
