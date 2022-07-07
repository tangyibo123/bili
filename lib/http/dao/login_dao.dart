import 'package:bili/db/hi_cache.dart';
import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/login_request.dart';
import 'package:bili/http/request/registration_request.dart';

class LoginDao {
  /// 登录令牌
  static const BOARDING_PASS = 'boarding-pass';

  /// 登录
  static login(String userName, String password) {
    return _send(userName, password);
  }

  /// 注册
  static registration(
      String userName, String password) {
    return _send(userName, password);
  }

  /// 发送
  static _send(String userName, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request.add('userName', userName).add('password', password);

    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      // 保存登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  /// 获取登录令牌
  static String? getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
