import 'package:yuonsoft/src/board/models/model_storage_image.dart';

class ModelWriteGuestPrivate {
  final String content;
  final List<ModelStorageImage> images;
  final String? email;
  final String? phone;

  ModelWriteGuestPrivate({
    required this.content,
    required this.images,
    required this.email,
    required this.phone,
  });

  ModelWriteGuestPrivate.fromJson(Map<String, Object?> json)
      : this(
          content: json['content']! as String,
          images:
              (json['images']! as List).map((e) => ModelStorageImage.fromJson(e)).toList(),
          email: json['email'] as String?,
          phone: json['phone'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'images': images.map((e) => e.toJson()),
      'email': email,
      'phone': phone,
    };
  }
}
