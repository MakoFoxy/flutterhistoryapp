import 'package:mausoleum/videorepo/video_quality_model.dart';

class VideoDownloadModel {
  String? _title;
  String? _source;
  String? _thumbnails;
  List<VideoQualityModel>? _videos;

  VideoDownloadModel({
    String? title,
    String? source,
    String? duration,
    String? thumbnails,
    List<VideoQualityModel>? videos,
  }) {
    if (title != null) {
      _title = title;
    }
    if (source != null) {
      _source = source;
    }
    if (thumbnails != null) {
      _thumbnails = thumbnails;
    }
    if (videos != null) {
      _videos = videos;
    }
  }
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get source => _source;
  set source(String? source) => _source = source;

  String? get thumbnails => _thumbnails;
  set thumbnails(String? thumbnails) => _thumbnails = thumbnails;

  List<VideoQualityModel>? get videos => _videos;
  set videos(List<VideoQualityModel>? videos) => _videos = videos;

  VideoDownloadModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _source = json['source'];
    _thumbnails = json['thumbnails'];
    _videos = json['videos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = _title;
    data['source'] = _source;
    data['thumbnails'] = _thumbnails;
    data['videos'] = _videos;
    return data;
  }
}
