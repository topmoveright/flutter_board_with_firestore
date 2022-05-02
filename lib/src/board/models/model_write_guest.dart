import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yuonsoft/src/board/core/extensions/extension_date_time.dart';


class ModelWriteGuest {
  // final String id;
  final String? category;
  final String subject;
  final dynamic timeReg;
  final dynamic timeUpdate;
  final String? parentId;
  final String name;

  ModelWriteGuest({
    // required this.id,
    required this.category,
    required this.subject,
    required this.timeReg,
    required this.timeUpdate,
    required this.parentId,
    required this.name,
  });

  String get strRegDT => (timeReg as DateTime).isSameDate(DateTime.now())
      ? DateFormat('HH:mm:ss').format(timeReg)
      : DateFormat('yyyy-MM-dd').format(timeReg);

  ModelWriteGuest.fromJson(Map<String, Object?> json)
      : this(
          // id: json['id'] as String,
          category: json['category'] as String?,
          subject: json['subject']! as String,
          timeReg: (json['timeReg']! as Timestamp).toDate(),
          timeUpdate: (json['timeUpdate']! as Timestamp).toDate(),
          parentId: json['parentId'] as String?,
          name: json['name'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      // 'id': id,
      'category': category,
      'subject': subject,
      'timeReg': timeReg,
      'timeUpdate': timeUpdate,
      'parentId': parentId,
      'name': name,
    };
  }
}
