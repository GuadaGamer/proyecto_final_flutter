import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
 var imagePath;

Future<bool> uploadImage(File image) async {
  final imageName = DateTime.now();
  
  imagePath = "/users/${FirebaseAuth.instance.currentUser?.email}/$imageName.jpg";
  Reference ref = storage.ref().child(imagePath);

  ListResult list = await FirebaseStorage.instance.ref().child("/users/${FirebaseAuth.instance.currentUser?.email}/").listAll();
  List<Reference> items = list.items;
  for (Reference item in items) {
  
   await item.delete();
  }
  
  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

   String downloadURL = await ref.getDownloadURL();

  await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadURL);

  if(snapshot.state == TaskState.success){
    return true;
  }else{
    return false;
  }
}