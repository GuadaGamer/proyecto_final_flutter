import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmpresasFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;

  CollectionReference? _empresasCollection;
  CollectionReference? proyectosCollection;

  EmpresasFirebase() {
    _empresasCollection = _firebase.collection('empresas');
    proyectosCollection = _firebase.collection('proyectos');
  }

  Future<void> insEmpresa(Map<String, dynamic> map) async {
    return _empresasCollection!.doc().set(map);
  }

  Future<void> updEmpresa(Map<String, dynamic> map) async {
    var query = _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
    var snapshot = await query.get();
    if (snapshot.size > 0) {
      var docRef = snapshot.docs[0].reference;
      return await docRef.update(map);
    }
  }

  Future<void> updArrayEmpresa(String ids) async {
    var query = _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
    var snapshot = await query.get();
    var referenciaEliminar = proyectosCollection!.doc(ids);
    if (snapshot.size > 0) {
      var docRef = snapshot.docs[0].reference;
      return await docRef.update({
        'proyectos': FieldValue.arrayRemove([referenciaEliminar])
      });
    }
  }

  Future<void> updEmpresaCorreo(String idproyecto) async {
    var query = _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
    var snapshot = await query.get();
    if (snapshot.size > 0) {
      var docRef = snapshot.docs[0].reference;
      await docRef.update({
        'proyectos':
            FieldValue.arrayUnion([proyectosCollection?.doc(idproyecto)])
      });
    }
  }

  Future<void> updArrayFavoritos(String ids) async {
    var query = _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
    var snapshot = await query.get();
    var referenciaEliminar = proyectosCollection!.doc(ids);
    if (snapshot.size > 0) {
      var docRef = snapshot.docs[0].reference;
      return await docRef.update({
        'favoritos': FieldValue.arrayRemove([referenciaEliminar])
      });
    }
  }

  Future<void> updEmpresaFavoritos(String idproyecto) async {
    var query = _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
    var snapshot = await query.get();
    if (snapshot.size > 0) {
      var docRef = snapshot.docs[0].reference;
      await docRef.update({
        'favoritos':
            FieldValue.arrayUnion([proyectosCollection?.doc(idproyecto)])
      });
    }
  }

  Future<void> delEmpresa(String id) async {
    return _empresasCollection!.doc(id).delete();
  }

  Stream<QuerySnapshot> getOneEmpresa() {
    return _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
  }

  Stream<QuerySnapshot> getOneEmpresaProyects(String correo) {
    return _empresasCollection!.where('correo', isEqualTo: correo).snapshots();
  }

  Future<List<String>> getDocumentReferences() async {
    QuerySnapshot querySnapshot = await _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return List.empty();
    }
    DocumentSnapshot snapshot = querySnapshot.docs.first;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('proyectos')) {
      List<DocumentReference> references = List.from(snapshot.get('proyectos'));
      List<String> ids = references.map((e) => e.id).toList();
      return ids;
    }
    return List.empty();
  }

  Future<List<String>> getFavoriteReferences() async {
    QuerySnapshot querySnapshot = await _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return List.empty();
    }
    DocumentSnapshot snapshot = querySnapshot.docs.first;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('favoritos')) {
      List<DocumentReference> references = List.from(snapshot.get('favoritos'));
      List<String> ids = references.map((e) => e.id).toList();
      return ids;
    }
    return List.empty();
  }

  Future<bool> existeDocumento() async {
    QuerySnapshot querySnapshot = await _empresasCollection!
        .where('correo', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
