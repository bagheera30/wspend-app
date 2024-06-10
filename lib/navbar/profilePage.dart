import 'dart:io';
import 'package:Wspend/provider/cameraHelper.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String profileName = ''; // Nilai awal untuk nama profil
  String phoneNumber = ''; // No Handphone
  String email = ''; // Email
  List<CameraDescription> cameras = [];
  File? _image;

  final userDocument = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  void presSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> saveProfileImageToFirebase(File image) async {
    final storage =
        FirebaseStorage.instanceFor(bucket: 'gs://wspend-509a7.appspot.com');
    final ref =
        storage.ref().child('profile_images').child('profile_image.jpg');

    try {
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();

      // Simpan URL gambar ke Firestore
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      await userDoc.update({'profileImageUrl': imageUrl});

      print('Image URL saved to Firestore: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  void showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedProfileName = profileName;
        String editedPassword = '';

        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  editedProfileName = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  editedPassword = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update profile name
                setState(() {
                  profileName = editedProfileName;
                });
                await userDocument.update({'name': editedProfileName});

                // Update password
                if (editedPassword.isNotEmpty) {
                  try {
                    await currentUser?.updatePassword(editedPassword);
                    print('Password updated successfully');
                  } catch (e) {
                    print('Error updating password: $e');
                  }
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userDocument.snapshots().listen((snapshot) {
      setState(() {
        profileName = snapshot.data()?['name'] ?? '';
        phoneNumber = snapshot.data()?['phone'];
      });
    });
    loadCameras();
  }

  Future<void> loadCameras() async {
    try {
      cameras = await CameraHelper.loadCameras();
    } catch (e) {
      print('Error loading cameras: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      await saveProfileImageToFirebase(_image!);
    }
  }

  Future<void> _takePicture() async {
    final camera = cameras.first;
    final pictureFile = await CameraHelper.takePicture(camera);

    if (pictureFile != null) {
      setState(() {
        _image = pictureFile;
      });

      final storage =
          FirebaseStorage.instanceFor(bucket: 'gs://wspend-509a7.appspot.com');
      final ref =
          storage.ref().child('profile_images').child('profile_image.jpg');

      try {
        await ref.putFile(_image!);
        final imageUrl = await ref.getDownloadURL();

        // Simpan URL gambar ke Firestore
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid);
        await userDoc.update({'profileImageUrl': imageUrl});

        print(
            'Image uploaded to Firebase Storage and URL saved to Firestore: $imageUrl');
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Kamera'),
                onTap: () {
                  _takePicture();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
                Text(
                  "Profile",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(143, 119, 119, 119),
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
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                  child: _image == null
                                      ? const Icon(Icons.account_circle, size: 40)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: _showImagePickerDialog,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            profileName,
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: showEditProfileDialog,
                                            icon: const Icon(Icons.edit),
                                          )
                                        ],
                                      ),
                                      Text(phoneNumber),
                                      Text(currentUser?.email ?? ''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: presSignOut,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Keluar Akun',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
