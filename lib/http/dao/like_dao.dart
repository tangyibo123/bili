import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/cancel_like_request.dart';
import 'package:bili/http/request/like_request.dart';

class LikeDao {
  static like(String vid, bool like) async {
    BaseRequest request = like ? LikeRequest() : CancelLikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
