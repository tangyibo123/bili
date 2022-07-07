import 'package:flutter/material.dart';
import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/pages/home_tab_page.dart';
import 'package:bili/pages/profile_page.dart';
import 'package:bili/pages/video_detail_page.dart';
import 'package:bili/provider/theme_provider.dart';
import 'package:bili/util/hi_state.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widgets/hi_tab.dart';
import 'package:bili/widgets/loading_container.dart';
import 'package:bili/widgets/hi_navigation_bar.dart';
import 'package:bili/widgets/view_util.dart';
import 'package:provider/provider.dart';

/// 首页
class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  /// 路由监听器
  var listener;

  /// 控制器
  TabController? _controller;

  /// 类别列表
  List<CategoryModel> categoryList = [];

  /// 轮播图列表
  List<BannerModel> bannerList = [];

  /// 加载状态
  bool _isLoading = true;

  /// 缓存页面
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _controller = TabController(
      length: categoryList.length,
      vsync: this,
    );
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      // 当页面返回到首页恢复首页的状态栏样式
      if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
        var statusStyle = StatusStyle.DARK_CONTENT;
        changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    HiNavigator.getInstance().removeListener(this.listener);
    _controller?.dispose();
    super.dispose();
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
      case AppLifecycleState.inactive:
        break;
      // 从后台切换前台，界面可见
      case AppLifecycleState.resumed:
        // fix Android 压后台首页状态栏字体颜色变白，详情页状态栏字体变黑问题
        changeStatusBar();
        break;
      // 界面不可见，后台
      case AppLifecycleState.paused:
        break;
      // APP 结束时调用
      case AppLifecycleState.detached:
        break;
    }
  }

  /// 监听系统Dark Mode变化
  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darModeChange();
    super.didChangePlatformBrightness();
  }

  /// 加载数据
  void loadData() async {
    try {
      HomeModel res = await HomeDao.get('推荐');
      if (res.categoryList != null) {
        _controller =
            TabController(length: res.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = res.categoryList ?? [];
        bannerList = res.bannerList ?? [];
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// appBar
  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                height: 46,
                width: 46,
                image: AssetImage('assets/images/avatar.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.search, color: Colors.grey),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // _mockCrash();
            },
            child: Icon(
              Icons.explore_outlined,
              color: Colors.grey,
            ),
          ),
          InkWell(
            onTap: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.notice);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 顶部 Tab
  Widget _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Column(
          children: [
            HiNavigationBar(
              child: _appBar(),
              height: 50,
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
            ),
            Container(
              decoration: bottomBoxShadow(context),
              child: _tabBar(),
            ),
            Flexible(
              child: TabBarView(
                controller: _controller,
                children: categoryList.map((tab) {
                  return HomeTabPage(
                    categoryName: tab.name,
                    bannerList: tab.name == '推荐' ? bannerList : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
