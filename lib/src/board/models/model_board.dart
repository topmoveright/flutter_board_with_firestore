import 'package:yuonsoft/src/board/models/model_user.dart';

enum BoardPermission { all, read, write }
enum BoardType { write, gallery, qna }

class ModelBoard {
  final String id;
  final UserRole userRole;
  final String title;
  final BoardType boardType;
  final BoardPermission boardPermission;

  ModelBoard({
    required this.id,
    required this.userRole,
    required this.title,
    required this.boardType,
    required this.boardPermission,
  });
}
