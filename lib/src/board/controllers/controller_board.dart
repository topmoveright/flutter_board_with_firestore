import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/core/extensions/extention_string.dart';
import 'package:yuonsoft/src/board/core/routes/route_board.dart';
import 'package:yuonsoft/src/board/core/services/service_board.dart';
import 'package:yuonsoft/src/board/core/services/service_guest_board.dart';
import 'package:yuonsoft/src/board/core/services/service_upload.dart';
import 'package:yuonsoft/src/board/models/model_board.dart';
import 'package:yuonsoft/src/board/models/model_storage_image.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';
import 'package:yuonsoft/src/board/models/model_write_guest_private.dart';

class ControllerBoard extends GetxController {

  ControllerBoard({required this.boardId});

  late String boardCollection = 'board-guest';
  late ServiceGuestBoard serviceBoard = ServiceGuestBoard(boardCollection);
  late ServiceUpload serviceUpload = ServiceUpload(boardCollection);

  final writeMaxImageCount = 2;
  final _allowUploadFileExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'tiff',
    'pdf',
    'ppt',
    'doc',
    'docx',
    'hwp',
    'txt'
  ];

  int _pagePerCount = 10;

  set setPagePerCount(int count) => _pagePerCount = count;

  final ServiceBoard _serviceBoard = Get.find<ServiceBoard>();

  // ## board data ##
  final String boardId; // TODO : boardId?? 그냥 board? 넘기기
  late ModelBoard board;
  final List<QueryDocumentSnapshot<ModelWriteGuest>> _writeList = [];

  List<ModelWriteGuest> get writeList =>
      _writeList.map((e) => e.data()).toList();

  void _showProgress() {
    Get.dialog(
      const Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _closeProgress() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<void> loadWriteList() async {
    // TODO : classic pagination 제외. 검색과 next prev로 대신 하기로함
    // fire store 에서 auto increment 지원하지 않음
    // 구현 할 순 있으나 불필요한 쿼리 요청이 많아 자원 낭비 예상됨
    _showProgress();
    var newWriteList = await serviceBoard.list(
      lastItem: _writeList.isEmpty ? null : _writeList.last,
      limit: _pagePerCount,
    );
    _writeList.addAll(newWriteList);
    update();
    _closeProgress();
  }

  void goWrite(int index) async {
    var textController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    final ModelWriteGuestPrivate? private = await Get.defaultDialog(
      title: '비밀번호 입력',
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: textController,
          autocorrect: false,
          obscureText: true,
          enableSuggestions: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 입력해 주세요.';
            }
            return null;
          },
        ),
      ),
      confirm: TextButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            var password = textController.text.trim();
            var value = await serviceBoard.getPrivate(
              id: _writeList[index].id,
              password: password.convertSha1,
            );
            Get.back(result: value);
          }
        },
        child: const Text('확인'),
      ),
    );
    if (private != null) {
      Get.toNamed(
        RouteBoard.write,
        arguments: {
          'write': writeList[index],
          'private': private,
        },
      );
    } else {
      Get.closeAllSnackbars();
      Get.snackbar('알림', '비밀번호를 확인해 주세요.');
    }
  }

  void goWriteCreate() {
    Get.toNamed(RouteBoard.writeCreate, arguments: this);
  }

  Future<void> actWriteCreate({
    required String password,
    required String subject,
    required String name,
    required String content,
    required String phone,
    required String email,
    required List<PlatformFile?> images,
  }) async {
    String? _emptyToNull(String string) {
      if (string.isEmpty) {
        return null;
      } else {
        return string;
      }
    }

    var time = FieldValue.serverTimestamp();
    var encryptPassword = password.convertSha1;

    var writeId = await serviceBoard.createWriteGuest(
      password: encryptPassword,
      write: ModelWriteGuest(
        category: null,
        subject: subject.stripHtmlTags,
        timeReg: time,
        timeUpdate: time,
        parentId: null,
        name: name.stripHtmlTags,
      ),
    );

    List<ModelStorageImage> imageDataList = [];
    try {
      await Future.forEach<PlatformFile?>(images, (e) async {
        if (e != null) {
          var imageData = await serviceUpload.uploadGuest(
            data: e.bytes!,
            extension: e.extension!,
            oriName: e.name,
            password: encryptPassword,
            writeId: writeId,
          );

          if (imageData != null) {
            imageDataList.add(imageData);
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    await serviceBoard.createWriteGuestPrivate(
      writeId: writeId,
      password: encryptPassword,
      writePrivate: ModelWriteGuestPrivate(
        content: content,
        images: imageDataList,
        email: _emptyToNull(email.stripHtmlTags),
        phone: _emptyToNull(phone.stripHtmlTags),
      ),
    );
  }

  Future<PlatformFile?> fileSelect() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowUploadFileExtensions,
    );

    bool _isAllowExtension(String extension) {
      return _allowUploadFileExtensions.contains(extension);
    }

    if (result != null) {
      var maxFileSize = 1;

      if (1024 * 1024 * 1 < result.files.single.size) {
        Get.closeAllSnackbars();
        Get.snackbar('알림', '파일크기를 확인해 주세요.( 최대 $maxFileSize MB )');
      } else if (!_isAllowExtension(result.files.single.extension!)) {
        Get.closeAllSnackbars();
        Get.snackbar('알림',
            '이미지나 문서파일만 첨부 가능합니다.\n( 허용형식: ${_allowUploadFileExtensions.join(', ')} )');
      } else {
        return result.files.single;
      }
    }
  }

  void _init(String boardCollectionPath) {
    boardCollection = boardCollectionPath;
    serviceBoard = ServiceGuestBoard(boardCollection);
    serviceUpload = ServiceUpload(boardCollection);
  }

  void _initAfterBuild() {
    if (_serviceBoard.boardList.any((e) => e.id == boardId)) {
      board = _serviceBoard.boardList.singleWhere((e) => e.id == boardId);
      loadWriteList();
    } else {
      Get.offAllNamed(RouteBoard.notFound);
    }
  }

  @override
  void onInit() {
    _init('board-guest');
    super.onInit();
  }

  @override
  void onReady() {
    _initAfterBuild();
    super.onReady();
  }
}
