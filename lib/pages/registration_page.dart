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

/// 注册页
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  /// 是否保护
  bool protect = false;

  /// 按钮是否可点击
  bool loginEnable = false;

  /// 用户名
  String? userName;

  /// 密码
  String? password;

  /// 确认密码
  String? rePassword;

  /// 慕课网 id
  //String? imoocId;

  /// 订单 id
  //String? orderId;

  /// 设置按钮启用
  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword))
    {
      enable = true;
    }
    else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  /// 检查密码
  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    }
    if (tips != null) {
      showWarnToast(tips);
      return;
    }
    send();
  }

  /// 注册
  void send() async {
    try {
      var result =
          await LoginDao.registration(userName!, password!);
      if (result['code'] == 0) {
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
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
      appBar: appBar('注册', '登录', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        // 自适应键盘弹起，防止遮挡
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户名',
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
            LoginInput(
              '确认密码',
              '请再次输入密码',
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
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
                '注册',
                enable: loginEnable,
                onPressed: checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }
}
