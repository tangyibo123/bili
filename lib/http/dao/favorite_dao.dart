import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/cancel_favorite_request.dart';
import 'package:bili/http/request/favorite_list_request.dart';
import 'package:bili/http/request/favorite_request.dart';
import 'package:bili/model/ranking_model.dart';

class FavoriteDao {
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
    favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    FavoriteListRequest request = FavoriteListRequest();
    request.add('pageIndex', pageIndex)
        .add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingModel.fromJson(result['data']);
  }
}
