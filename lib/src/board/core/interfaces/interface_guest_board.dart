import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';
import 'package:yuonsoft/src/board/models/model_write_guest_private.dart';

abstract class InterfaceGuestBoard {
  list({
    QueryDocumentSnapshot lastItem,
    required int limit,
  });

  getPrivate({
    required String id,
    required String password,
  });

  createWriteGuest({
    required String password,
    required ModelWriteGuest write,
  });

  createWriteGuestPrivate({
    required String writeId,
    required String password,
    required ModelWriteGuestPrivate writePrivate,
  });

  update();

  delete();
}
