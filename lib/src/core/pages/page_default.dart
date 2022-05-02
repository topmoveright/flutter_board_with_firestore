import 'package:get/get.dart';
import 'package:yuonsoft/src/board/core/pages/page_board.dart';
import 'package:yuonsoft/src/core/routes/route_default.dart';
import 'package:yuonsoft/src/views/view_home.dart';
import 'package:yuonsoft/src/views/view_template_not_available.dart';
import 'package:yuonsoft/src/views/view_template_not_found.dart';

abstract class PageDefault {
  static final List<GetPage> list = [
    GetPage(
      name: RouteDefault.home,
      page: () => ViewHome(),
    ),
    GetPage(
      name: RouteDefault.notAvailable,
      page: () => const ViewTemplateNotAvailable(),
    ),
    notFound,
    ...PageBoard.list,
  ];

  static final notFound = GetPage(
    name: RouteDefault.notFound,
    page: () => const ViewTemplateNotFound(),
  );
}
