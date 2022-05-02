import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/controllers/controller_board.dart';
import 'package:yuonsoft/src/board/views/view_layout_board.dart';

class ViewBoard extends GetView<ControllerBoard> {
  const ViewBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewLayoutBoard(
      child: Column(
        children: [
          Expanded(
            child: GetBuilder<ControllerBoard>(
              builder: (ctl) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: ctl.writeList.length,
                  itemBuilder: (context, index) {
                    var write = ctl.writeList[index];
                    return ListTile(
                      leading: Text(write.name),
                      title: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          // onTap: () => Get.toNamed('/write', arguments: []),
                          onTap: () => ctl.goWrite(index),
                          child: Text(write.subject),
                        ),
                      ),
                      trailing: Text(write.strRegDT),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => controller.goWriteCreate(),
                  icon: const Icon(Icons.create),
                  label: const Text('글쓰기'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.find<ControllerBoard>().loadWriteList(),
            child: const Text('더보기'),
          ),
        ],
      ),
    );
  }
}
