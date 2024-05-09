import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb_wespend/auth/login.dart';
import 'package:tubes_ppb_wespend/provider/authProvider.dart';

class Regis extends StatefulWidget {
  const Regis({Key? key}) : super(key: key);

  @override
  State<Regis> createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  final _authProvider = AuthProvider();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordMatch = true;
  void validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        isEmailValid = true;
      } else {
        isEmailValid = email.contains('@');
      }
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  void validatePasswordMatch(String value) {
    setState(() {
      isPasswordMatch = value == passwordController.text;
    });
  }

  Future<void> submitForm() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }
    try {
      final user = await _authProvider.signUp(name, phone, email, pass);

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
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
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ayo mulai bijak dengan keuanganmu di aplikasi WSpend!",
                          style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(fontSize: 20, fontFamily: "Roboto"),
                          ),
                        )
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
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'No HP',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
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
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Konfirmasi Password",
                          //   style: GoogleFonts.roboto(
                          //     textStyle: TextStyle(fontSize: 20),
                          //   ),
                          // ),
                          TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: toggleConfirmPasswordVisibility,
                              ),
                            ),
                            obscureText: !isConfirmPasswordVisible,
                            onChanged: validatePasswordMatch,
                          ),
                          if (!isPasswordMatch)
                            const Text(
                              "Password tidak sama",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: submitForm,
                  child: Text(
                    "Buat Akun",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Warna teks
                    minimumSize:
                        const Size(double.infinity, 50), // Tombol selebar layar
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Sudut melengkung
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
