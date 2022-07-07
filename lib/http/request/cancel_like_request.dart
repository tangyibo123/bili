import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/like_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
