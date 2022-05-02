import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/core/interfaces/interface_board.dart';
import 'package:yuonsoft/src/board/models/model_board.dart';
import 'package:yuonsoft/src/board/models/model_user.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';
import 'package:yuonsoft/src/sample_feature/sample_dummy.dart';

class ServiceBoard extends GetxService implements InterfaceBoard {

  @override
  List<ModelBoard> boardList = [];

  @override
  Future<ServiceBoard> init() async {
    debugPrint('$runtimeType wait for board list');
    await setBoardList();
    debugPrint('$runtimeType ready!');
    return this;
  }

  @override
  Future<void> setBoardList() async {
    await 0.5.delay();
    boardList =  [
      ModelBoard(
        id: '1',
        userRole: UserRole.guest,
        title: '기본게시판',
        boardType: BoardType.write,
        boardPermission: BoardPermission.read,
      ),
    ];
  }

  @override
  Future<int> totalCount(ModelBoard board) async {
    await 0.5.delay();
    return [...SampleDummy.writeList].length;
  }

  @override
  Future<List<ModelWriteGuest>> writeList({
    required ModelBoard board,
    required int start,
    required int end,
  }) async {
    await 1.delay();
    var dummyList = [...SampleDummy.writeList];
    //dummyList.sort((a, b) => b.id - a.id);
    return dummyList.sublist(start, end);
  }


}
