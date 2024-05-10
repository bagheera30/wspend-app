import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonImage extends StatelessWidget {
  final String image;
  final VoidCallback onPress;
  final String teks;
  const ButtonImage(
      {super.key,
      required this.image,
      required this.onPress,
      required this.teks});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 173, 165, 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Sudut melengkung
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 30,
            width: 30,
          ),
          const SizedBox(width: 30), // Add spacing between image and text
          Text(
            teks,
            style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
