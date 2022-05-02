import 'package:get/get.dart';
import 'package:yuonsoft/src/board/controllers/controller_board.dart';
import 'package:yuonsoft/src/board/core/routes/route_board.dart';
import 'package:yuonsoft/src/board/views/view_board.dart';
import 'package:yuonsoft/src/board/views/view_write.dart';
import 'package:yuonsoft/src/board/views/view_write_create.dart';

abstract class PageBoard {
  static final List<GetPage> list = [
    GetPage(
      name: '${RouteBoard.board}/:boardId',
      page: () => const ViewBoard(),
      binding: BindingsBuilder(() {
        Get.put(ControllerBoard(boardId: Get.parameters['boardId'] ?? ''));
      }),
    ),
    GetPage(
      name: RouteBoard.write,
      page: () =>  const ViewWrite(),
      preventDuplicates: true,
    ),
    GetPage(
      name: RouteBoard.writeCreate,
      page: () => const ViewWriteCreate(),
      preventDuplicates: true,
    ),
  ];
}
