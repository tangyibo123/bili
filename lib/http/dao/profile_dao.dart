import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/profile_request.dart';
import 'package:bili/model/profile_model.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileModel.fromJson(result['data']);
  }
}
