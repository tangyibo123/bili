import 'package:flutter/material.dart';
import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/login_dao.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/util/string_util.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widgets/appbar.dart';
import 'package:bili/widgets/login_button.dart';
import 'package:bili/widgets/login_effect.dart';
import 'package:bili/widgets/login_input.dart';

/// 登录页
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// 是否保护
  bool protect = false;

  /// 按钮是否可点击
  bool loginEnable = false;

  /// 用户名
  String? userName;

  /// 密码
  String? password;

  /// 设置登录按钮
  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  /// 登录
  void send() async {
    try {
      HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      var result = await LoginDao.login(userName!, password!);
      if (result['code'] == 0) {
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }, key: Key('registration')),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '登录',
                enable: loginEnable,
                onPressed: send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
