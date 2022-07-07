import 'package:flutter/material.dart';
import 'package:bili/http/dao/favorite_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/model/ranking_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/pages/video_detail_page.dart';
import 'package:bili/widgets/hi_base_tab_state.dart';
import 'package:bili/widgets/hi_navigation_bar.dart';
import 'package:bili/widgets/video_large_card.dart';
import 'package:bili/widgets/view_util.dart';

/// 收藏
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState
    extends HiBaseTabState<RankingModel, VideoModel, FavoritePage> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            VideoLargeCard(videoInfo: dataList[index]),
      );

  @override
  Future<RankingModel> getData(int pageIndex) async {
    RankingModel result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }

  _buildNavigationBar() {
    return HiNavigationBar(
      child: Container(
        decoration: bottomBoxShadow(context),
        alignment: Alignment.center,
        child: Text(
          '收藏',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNavigationBar(),
        Expanded(child: super.build(context)),
      ],
    );
  }
}
