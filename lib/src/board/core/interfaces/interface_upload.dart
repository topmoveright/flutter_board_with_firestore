import 'dart:typed_data';

abstract class InterfaceUpload {
  uploadGuest({
    required Uint8List data,
    required String extension,
    required String oriName,
    required String password,
    required String writeId,
  });

  delete();

  get();

  list();
}
