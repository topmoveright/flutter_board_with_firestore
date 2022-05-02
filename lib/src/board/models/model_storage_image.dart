class ModelStorageImage {
  final String link;
  final String name;

  ModelStorageImage(this.link, this.name);

  ModelStorageImage.fromJson(Map<String, Object?> json)
      : this(
          json['link'] as String,
          json['name'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'link' : link,
      'name' : name,
    };
  }
}
