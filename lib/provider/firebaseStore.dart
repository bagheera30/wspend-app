import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final Reference _storage = FirebaseStorage.instance.ref();

  Future<String> uploadImage(String path, File imageFile) async {
    Reference storageReference = _storage.child(path);
    UploadTask uploadTask = storageReference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> getImageUrl(String path) async {
    Reference storageReference = _storage.child(path);
    return await storageReference.getDownloadURL();
  }
}
