import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/video_detail_request.dart';
import 'package:bili/model/video_detail_model.dart';

/// 视频详情页
class VideoDetailDao {
  // https://api.devio.org/uapi/fa/detail/BV19C4y1s7Ka
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return VideoDetailModel.fromJson(result['data']);
  }
}
