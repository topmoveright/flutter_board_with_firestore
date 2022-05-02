import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/views/view_template_desktop_board.dart';
import 'package:yuonsoft/src/board/views/view_template_phone_board.dart';
import 'package:yuonsoft/src/board/views/view_template_tablet_board.dart';
import 'package:yuonsoft/src/views/view_layout.dart';

class ViewLayoutBoard extends GetResponsiveView {
  ViewLayoutBoard({Key? key, required this.child}) : super(key: key);

  final Widget child;
  // 브랜치 테스트

  @override
  Widget? builder() {
    late Widget view;
    switch (screen.screenType) {
      case ScreenType.Watch:
        view = const SizedBox.shrink();
        break;
      case ScreenType.Phone:
        view = ViewTemplatePhoneBoard(child: child);
        break;
      case ScreenType.Tablet:
        view = ViewTemplateTabletBoard(child: child);
        break;
      case ScreenType.Desktop:
        view = ViewTemplateDesktopBoard(child: child);
        break;
    }

    return ViewLayout(child: view);
  }
}
