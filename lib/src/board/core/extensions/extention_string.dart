import 'dart:convert';
import 'package:crypto/crypto.dart';

extension ExtensionString on String {
  String get stripHtmlTags =>
     replaceAll("(?s)<(\\w+)\\b[^<>]*>.*?</\\1>", "");

  String get convertSha1 {
    var bytes = utf8.encode(this);
    return sha1.convert(bytes).toString();
  }

}