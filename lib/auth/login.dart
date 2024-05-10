import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb_wespend/auth/regis.dart';
import 'package:tubes_ppb_wespend/home.dart';
import 'package:tubes_ppb_wespend/provider/authProvider.dart';
import 'package:tubes_ppb_wespend/winget/buttonImage.dart';
import 'package:tubes_ppb_wespend/winget/buttonWinget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordVisible = false;

  final _authProvider = AuthProvider();

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Regis(), // Navigasi ke halaman Regis
      ),
    );
  }

  Future<void> KlikGoogle() async {
    try {
      await _authProvider.signInWithGoogle();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> submitForm() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }

    try {
      // Menampilkan CircularProgressIndicator() sebelum await _authProvider.signIn()

      await _authProvider.signIn(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(), // Navigasi ke halaman Regis
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "WSpend",
                  style: GoogleFonts.vampiroOne(
                    fontSize: 30,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ayo mulai bijak dengan keuanganmu di aplikasi WSpend!",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email address';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address @';
                              }
                              return null; // Return null if the input is valid
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: togglePasswordVisibility,
                              ),
                            ),
                            obscureText: !isPasswordVisible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Buttonwinget(
                  onPress: submitForm,
                  text: 'Masuk',
                  minimumsize1: double.infinity,
                  minimumsize2: 50,
                ),
                const SizedBox(height: 18),
                Text(
                  "----------- Atau -----------",
                  style: GoogleFonts.roboto(fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonImage(
                  image: "assets/images/google.png",
                  onPress: KlikGoogle,
                  teks: 'GOOGLE',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'belum punya akun',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 0), // Menambahkan space horizontal
                    TextButton(
                      onPressed: goToRegisterPage,
                      child: Text(
                        'register',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(fontSize: 17)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
