import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuonsoft/src/board/models/model_write_guest.dart';
import 'package:yuonsoft/src/board/models/model_write_guest_private.dart';
import 'package:yuonsoft/src/core/routes/route_default.dart';
import 'package:yuonsoft/src/views/view_layout.dart';

class ViewWrite extends StatefulWidget {
  const ViewWrite({Key? key}) : super(key: key);

  @override
  State<ViewWrite> createState() => _ViewWriteState();
}

class _ViewWriteState extends State<ViewWrite> {
  late ModelWriteGuest? write;
  late ModelWriteGuestPrivate? private;

  bool get canShow => write != null && private != null;

  @override
  void initState() {
    try {
      write = Get.arguments['write'];
      private = Get.arguments['private'];
    } catch (e) {
      write = null;
      private = null;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (!canShow) {
          Get.offAndToNamed(RouteDefault.home);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      child: Center(
        child: !canShow
            ? const CircularProgressIndicator()
            : ListView(
                children: [
                  buildListTile(
                    title: const Text('날짜'),
                    child: Text(write!.strRegDT),
                  ),
                  buildListTile(
                    title: const Text('제목'),
                    child: Text(write!.subject),
                  ),
                  buildListTile(
                    title: const Text('이름'),
                    child: Text(write!.name),
                  ),
                  buildListTile(
                    title: const Text('연락처'),
                    child: Text(private!.phone ?? ''),
                  ),
                  buildListTile(
                    title: const Text('이메일'),
                    child: Text(private!.email ?? ''),
                  ),
                  buildListTile(
                    title: const Text('내용'),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 300),
                      child: Text(private!.content),
                    ),
                  ),
                  buildListTile(
                    title: const Text('파일'),
                    child: Column(
                      children: List.generate(
                        private!.images.length,
                        (index) => TextButton.icon(
                          onPressed: () => launch(
                            private!.images[index].link,
                            forceWebView: true,
                          ),
                          icon: const Icon(Icons.file_download),
                          label: Text(private!.images[index].name),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  ListTile buildListTile({
    required Widget title,
    required Widget child,
  }) {
    return ListTile(
      leading: title,
      title: child,
      dense: true,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 100.0,
    );
  }
}
