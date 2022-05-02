import 'package:yuonsoft/src/board/models/model_board.dart';

abstract class InterfaceBoard {
  List<ModelBoard> boardList = [];

  Future<InterfaceBoard> init() async {
    return this;
  }

  Future<void> setBoardList() async {}

  void totalCount(ModelBoard board) {}

  void writeList({
    required ModelBoard board,
    required int start,
    required int end,
  }) {}
}
