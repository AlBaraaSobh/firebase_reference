import 'dart:io';

import 'package:elancer_firebase/models/fb_response.dart';
import 'package:elancer_firebase/utils/firebase_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FbStorageController with FirebaseHelper {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask upload(String path)  {
    UploadTask uploadTask = _storage
        .ref('images/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(File(path));
    return uploadTask;
  }

  Future<List<Reference>> read() async {
    ListResult listResult = await _storage.ref('images').listAll();
    if(listResult.items.isNotEmpty){
      return listResult.items;
    }
    return [];
  }

  Future<FbResponse> delete(String path) async {
    return await _storage.ref(path).delete().then((
        value) => successResponse,).catchError((error) => failedResponse);

  }
}
