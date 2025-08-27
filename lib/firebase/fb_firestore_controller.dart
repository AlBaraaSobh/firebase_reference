import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_firebase/models/fb_response.dart';
import 'package:elancer_firebase/utils/firebase_helper.dart';

import '../../models/note.dart';

class FbFirestoreController with FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<FbResponse> create(Note note) async {
  //   return _firestore
  //       .collection('Notes')
  //       .add(note.toMap())
  //       .then((value) => successResponse)
  //       .catchError((error) => failedResponse);
  // }

  Future<FbResponse> create(Note note) async {
    return _firestore
        .collection('Notes')
        .add(note.toMap())
        .then((value) {
      note.id = value.id; // ✅ حفظ id
      return successResponse;
    })
        .catchError((error) => failedResponse);
  }




  Future<FbResponse> update(Note note) async {
    return _firestore
        .collection('Notes')
        .doc(note.id)
        .update(note.toMap())
        .then((value) => successResponse)
        .catchError((error) => failedResponse);
  }

  Future<FbResponse> delete(String id) async {
    return _firestore
        .collection('Notes')
        .doc(id)
        .delete()
        .then((value) => successResponse)
        .catchError((error) => failedResponse);
  }

  Stream<QuerySnapshot<Note>> read() async* {
    yield* _firestore
        .collection('Notes')
        .withConverter(
          fromFirestore: (snapshot, options) => Note.fromMap(snapshot.data()!),
          toFirestore: (value, option) => value.toMap(),
        ).snapshots();
  }
}
