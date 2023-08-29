// import 'dart:math';

// import 'package:extractor/extractor.dart';
// import 'package:mausoleum/videorepo/video_download_models.dart';
// import 'package:mausoleum/videorepo/video_quality_model.dart';

// class VideosDownloaderRepo {
//   Future<VideoDownloadModel?> getAvailableYTvideos(String url) async {
//     try {
//       final response = await Extractor.getDirectLink(link: url);
//       if (response != null) {
//         return VideoDownloadModel.fromJson({
//           "title": response.title,
//           "source": response.links?.first.href,
//           "thumbnail": response.thumbnail,
//           "videos": [
//             VideoQualityModel(
//               url: response.links?.first.href,
//               quality: "720",
//             )
//           ]
//         });
//       } else {
//         return null;
//       }
//     } on Exception catch (e) {
//       print("Exception occured $e");
//       return null;
//     }
//   }
// }
