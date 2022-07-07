import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/home_request.dart';
import 'package:bili/model/home_model.dart';

class HomeDao {
  // https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static Future<HomeModel> get(String categoryName,
      {int pageIndex = 1, int pageSize = 10}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return HomeModel.fromJson(result['data']);
  }
}
