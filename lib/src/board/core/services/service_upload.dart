import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/core/interfaces/interface_upload.dart';
import 'package:yuonsoft/src/board/models/model_storage_image.dart';

class ServiceUpload extends GetxService implements InterfaceUpload {
  final maxUploadSize = 5; // MB
  final _storage = firebase_storage.FirebaseStorage.instance;
  late firebase_storage.Reference _ref;

  ServiceUpload(String path) {
    _ref = _storage.ref(path);
  }

  String getDownloadUrl(String uploadedName, String password) {
    var bucket = firebase_storage.FirebaseStorage.instance.bucket;
    var uriEncodedName = Uri.encodeComponent('${_ref.fullPath}/$uploadedName');
    return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$uriEncodedName?password=$password&alt=media';
  }

  @override
  delete() {}

  @override
  get() {}

  @override
  list() {}

  @override
  Future<ModelStorageImage?> uploadGuest({
    required Uint8List data,
    required String extension,
    required String oriName,
    required String password,
    required String writeId,
  }) async {
    // * 비밀번호를 사용하는 게스트 전용 업로드
    // firebase storage rules 에서 getDownloadUrl() 사용위해서 get 권한필요 (토큰사용)
    // get 권한 허용하면 보안문제 가능성 up
    // 암호화된 비밀번호를 meta 태크에 넣어서 rules 에서 비교 하는것으로 결정

    try {
      var time = DateTime.now().millisecondsSinceEpoch.toString();
      /*var metadata =
          firebase_storage.SettableMetadata(contentType: 'image/$extension');*/
      var metadata = firebase_storage.SettableMetadata(
          customMetadata: {'password': password});
      var filename = await _ref
          .child('${writeId}_$time.$extension')
          .putData(data, metadata)
          .then((p0) => p0.ref.name);
      var link = getDownloadUrl(filename, password);
      return ModelStorageImage(link, oriName);
    } catch (e) {
      // print(e);
    }
  }
}
