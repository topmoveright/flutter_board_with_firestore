import 'package:yuonsoft/src/board/models/model_write_guest.dart';

abstract class SampleDummy {
  static List<ModelWriteGuest> writeList = [
    ...List.generate(
        50,
        (index) => ModelWriteGuest(
              // id: (index + 1).toString(),
              category: null,
              subject: '${index + 1} 테스트 입니다.',
              timeReg: DateTime.parse('2021-12-02'),
              timeUpdate: DateTime.parse('2021-12-02'),
              parentId: null,
              name: '',
            )),
  ];
}
