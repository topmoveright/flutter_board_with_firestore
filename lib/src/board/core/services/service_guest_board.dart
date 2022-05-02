import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/core/interfaces/interface_guest_board.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';
import 'package:yuonsoft/src/board/models/model_write_guest_private.dart';

class ServiceGuestBoard extends GetxService implements InterfaceGuestBoard {
  final _fireStore = FirebaseFirestore.instance;
  final String _collectionPath;
  late CollectionReference<ModelWriteGuest> _refWrite;

  ServiceGuestBoard(this._collectionPath) {
    _refWrite =
        _fireStore.collection(_collectionPath).withConverter<ModelWriteGuest>(
              fromFirestore: (snapshot, _) =>
                  ModelWriteGuest.fromJson(snapshot.data()!),
              toFirestore: (write, _) => write.toJson(),
            );
  }

  @override
  Future<String> createWriteGuest({
    required String password,
    required ModelWriteGuest write,
  }) async {
    var createdWrite = await _refWrite.add(write);
    return createdWrite.id;
  }

  @override
  Future<void> createWriteGuestPrivate({
    required String writeId,
    required String password,
    required ModelWriteGuestPrivate writePrivate,
  }) async {
    await _refWrite
        .doc(writeId)
        .collection(password)
        .doc('private')
        .set(writePrivate.toJson());
  }

  @override
  Future<void> delete() async {
    // TODO: implement delete
  }

  @override
  Future<ModelWriteGuestPrivate?> getPrivate({
    required String id,
    required String password,
  }) async {
    try {
      return await _refWrite
          .doc(id)
          .collection(password)
          .doc('private')
          .get()
          .then(
              (snapshot) => ModelWriteGuestPrivate.fromJson(snapshot.data()!));
    } catch (e) {
      // e.code : permission-denied
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<List<QueryDocumentSnapshot<ModelWriteGuest>>> list({
    QueryDocumentSnapshot? lastItem,
    required int limit,
  }) async {
    if (lastItem == null) {
      return await _refWrite
          .orderBy('timeUpdate', descending: true)
          .limit(limit)
          .get()
          .then((snapshot) => snapshot.docs);
    } else {
      return await _refWrite
          .orderBy('timeUpdate', descending: true)
          .startAfterDocument(lastItem)
          .limit(limit)
          .get()
          .then((snapshot) => snapshot.docs);
    }
  }

  @override
  Future<void> update() async {
    // TODO: implement update
  }
}
