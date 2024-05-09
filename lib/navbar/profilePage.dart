import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileName = 'Ridwan NR'; // Nilai awal untuk nama profil
  String phoneNumber = '08117687223'; // No Handphone
  String email = 'ridwan@gmail.com'; // Email

  void presSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.yellow[600],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Profile",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(143, 119, 119, 119),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.account_circle,
                              size: 40,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue: profileName,
                                  onChanged: (newValue) {
                                    setState(() {
                                      profileName = newValue;
                                    });
                                  },
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize:
                                              20)), // Ubah ukuran font nama
                                  decoration: InputDecoration(
                                    hintText: "Masukkan nama profil",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .transparent)), // Menghilangkan garis bawah
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .transparent)), // Menghilangkan garis bawah saat terfokus
                                    suffixIcon: Icon(Icons.edit,
                                        size: 20), // Tambahkan ikon pensil
                                  ),
                                ),
                                Text(phoneNumber),
                                Text(email),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Spasi antara Container pertama dan kedua
              ElevatedButton(
                onPressed: presSignOut, // Navigasi ke halaman Regis
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // Warna teks
                  minimumSize:
                      const Size(double.infinity, 50), // Tombol selebar layar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Sudut melengkung
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'keluar akun',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
