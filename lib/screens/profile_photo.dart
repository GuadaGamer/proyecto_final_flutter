import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> profilePhoto() async {
  // Obtener una referencia a la imagen
  ListResult list = await FirebaseStorage.instance.ref().child("/users/${FirebaseAuth.instance.currentUser?.email}/").list(ListOptions(maxResults: 1));
  Reference items = list.items.first;
  Reference ref = FirebaseStorage.instance.ref().child(items.fullPath);

  // Obtener la URL de descarga
  String downloadURL = await ref.getDownloadURL();
  return downloadURL;

  // Ahora puedes usar la URL de descarga para mostrar la imagen en tu aplicación
  // Por ejemplo, puedes usarla con un widget Image.network:
  // Image.network(downloadURL);
}