import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuonsoft/src/board/models/model_board.dart';
import 'package:yuonsoft/src/board/models/model_page_data.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';

class ModelPagingHistory {
  final ModelBoard board;
  final List<QueryDocumentSnapshot<ModelWriteGuest>> writeList;
  final ModelPageData pageData;

  ModelPagingHistory(this.board, this.writeList, this.pageData);
}
