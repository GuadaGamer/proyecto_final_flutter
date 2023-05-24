import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_web/Service/empresas_firebasa%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ProyectosFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;

  CollectionReference? _proyectosCollection;
  EmpresasFirebase? empresasFirebase = EmpresasFirebase();

  ProyectosFirebase() {
    _proyectosCollection = _firebase.collection('proyectos');
  }

  Future<void> insProyecto(Map<String, dynamic> map) async {
    return _proyectosCollection!.doc().set(map);
  }

  Future<void> updProyecto(Map<String, dynamic> map, String id) async {
    return _proyectosCollection!.doc(id).update(map);
  }

  Future<void> delProyecto(String id) async {
    return _proyectosCollection!.doc(id).delete();
  }

  Stream<QuerySnapshot> getAllProyecto() {
    return _proyectosCollection!.snapshots();
  }

  Stream<QuerySnapshot> getOneProyecto(String id) {
    final query =
        _proyectosCollection!.where(FieldPath.documentId, isEqualTo: id);
    return query.snapshots();
  }

  Future<String> getLastProyecto() async {
    var id = await _proyectosCollection!
        .orderBy('fecha', descending: true)
        .limit(1)
        .get();
    final documentID = id.docs.first.id;
    return documentID;
  }

  Future<void> insertarDonacion(Map<String, dynamic> map, String ids) async {
    final documentReference =
        FirebaseFirestore.instance.collection('proyectos').doc(ids);

    // Accede a la colección deseada dentro del documento padre
    final coleccionReference = documentReference.collection('donaciones');

    // Agrega un nuevo documento dentro de la colección
    await coleccionReference.add(map);
  }

  Stream<List<QueryDocumentSnapshot>> getAllDonations() {
    final collectionReference = _proyectosCollection!;

    return collectionReference.snapshots().asyncExpand((parentSnapshot) {
      final childReferences = parentSnapshot.docs
          .map((doc) => doc.reference.collection('donaciones'));
      final childStreams = childReferences.map((childReference) =>
          childReference
              .where('correo',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots());

      return Rx.combineLatestList<QuerySnapshot>(childStreams).map((snapshots) {
        final combinedDocs = snapshots.fold<List<QueryDocumentSnapshot>>(
          [],
          (previous, current) => previous..addAll(current.docs),
        );
        return combinedDocs;
      });
    });
  }

  Future<String> obtenerIdPadreDesdeHijo(String hijoId) async {
    QuerySnapshot querySnapshot =
        await _proyectosCollection // Nombre de la subcolección "hijos"
            !
            .get();
    for (QueryDocumentSnapshot documentoPrincipalSnapshot
        in querySnapshot.docs) {
      QuerySnapshot subcoleccionSnapshot = await documentoPrincipalSnapshot
          .reference
          .collection('donaciones')
          .where(FieldPath.documentId, isEqualTo: hijoId)
          .get();

      if (subcoleccionSnapshot.docs.isNotEmpty) {
        return documentoPrincipalSnapshot.id;
      }
    }
    throw Exception('No se encontró el documento hijo en la colección.');
  }
}
