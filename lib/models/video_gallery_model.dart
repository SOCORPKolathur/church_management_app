class GalleryVideoModel {
  String? id;
  String? videoUrl;
  String? thumbUrl;

  GalleryVideoModel({this.id, this.videoUrl,this.thumbUrl});

  GalleryVideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoUrl = json['videoUrl'];
    thumbUrl = json['thumbUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['videoUrl'] = videoUrl;
    data['thumbUrl'] = thumbUrl;
    return data;
  }
}