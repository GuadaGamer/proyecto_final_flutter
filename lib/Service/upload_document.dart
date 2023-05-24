import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
 var archivoPath;

Future<String?> uploadDocument(File archivo, String rfcSH) async {
  if (rfcSH.isEmpty) {
    rfcSH = DateTime.now().toString();
  }
  archivoPath = "/users/${FirebaseAuth.instance.currentUser?.email}/docs/$rfcSH";
  Reference ref = storage.ref().child(archivoPath);

  ListResult list = await FirebaseStorage.instance.ref().child("/users/${FirebaseAuth.instance.currentUser?.email}/docs/").listAll();
  List<Reference> items = list.items;
  for (Reference item in items) {
  
   await item.delete();
  }
  
  final UploadTask uploadTask = ref.putFile(archivo);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

   String downloadURL = await ref.getDownloadURL();

  if(snapshot.state == TaskState.success){
    return downloadURL;
  }else{
    return null;
  }
}