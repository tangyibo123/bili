import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/notice_request.dart';
import 'package:bili/model/notice_model.dart';

/// 通知列表
class NoticeDao {
  // https://api.devio.org/uapi/fa/notice?pageIndex=1&pageSize=10
  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return NoticeModel.fromJson(result['data']);
  }
}
