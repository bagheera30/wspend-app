import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonwinget extends StatelessWidget {
  final String text;
  final double? minimumsize1;
  final double? minimumsize2;
  final VoidCallback onPress;

  const Buttonwinget(
      {super.key,
      required this.onPress,
      required this.text,
      this.minimumsize1,
      this.minimumsize2});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color.fromARGB(255, 173, 165, 2),
          minimumSize: Size(minimumsize1 ?? 0, minimumsize2 ?? 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Sudut melengkung
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ));
  }
}
