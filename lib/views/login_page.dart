import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bot_toast/bot_toast.dart';
import '../utils/http_util.dart';
import '../utils/config.dart';
import '../store/user_store.dart';
import '../store/collect_store.dart';
import '../models/topic.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey _formKey = GlobalKey<FormState>();
  String _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'AccessToken',
                  hintText: '请输入CNodejs社区的AccessToken',
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                onSaved: (v) => _token = v,
                validator: (v) => v.trim().length > 0 ? null : '请输入正确的AccessToken',
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Text('登录'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: _doLogin,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Text('扫码登录'),
                          color: Colors.cyan,
                          textColor: Colors.white,
                          onPressed: _scanQrcode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 执行登录操作
  void _doLogin() {
    FormState form = _formKey.currentState as FormState;
    if(form.validate()) {
      form.save();
      _tokenCheck(_token);
    } else {
      BotToast.showText(text: '请输入AccessToken');
    }
  }

  // 扫描二维码
  void _scanQrcode() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      try {
        // 此处为扫码结果，barcode为二维码的内容
        String barcode = await BarcodeScanner.scan();
        _tokenCheck(barcode);
      } catch (e) {
        // 扫码错误
        BotToast.showText(text: '扫码错误: $e');
      }
    }
  }

  // 检查token
  void _tokenCheck(String token) async {
    try {
      // 检查token
      Result<dynamic> check = await HttpUtil.post('/accesstoken', data: { 'accesstoken': token });
      // 请求检查成功
      if (check.response.statusCode == 200 && check.success) {
        // 请求中设置默认携带token进行请求
        HttpUtil.setDefaultParams({ 'accesstoken': token });
        // 存储token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(Config.USER_TOKEN_KEY, token);
        // 存入到mobx
        String name = check.response.data['loginname'];
        userStore.setInfo(token, name, check.response.data['avatar_url']);
        // 初始化收藏的话题
        _initCollect(name);
        // 提示成功
        BotToast.showText(text: '登录成功');
        // 返回页面
        Navigator.of(context).pop();
      } else {
        BotToast.showText(text: '无效的AccessToken');
      }
    } catch (e) {
      // 登录失败
      BotToast.showText(text: '无效的AccessToken');
    }
  }

  // 初始化收藏的话题
  void _initCollect(String name) async {
    // 获取数据
    Result<List<dynamic>> result = await HttpUtil.get('/topic_collect/$name');
    // 数据结构转换
    List<Topic> topics = result.data.map((res) => Topic.fromJson(res as Map<String, dynamic>)).toList();
    // 存入mobx
    collectStore.setAll(topics);
  }
}