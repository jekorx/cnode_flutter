import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size/auto_size.dart';
import './utils/http_util.dart';
import './utils/config.dart';
import './views/home.dart';
import './store/collect_store.dart';
import './store/user_store.dart';
import './models/topic.dart';

void main() => runAutoSizeApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    // 初始化token相关
    _initToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }

  // 检查并初始化token
  void _initToken() async {
    // 获取token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Config.USER_TOKEN_KEY);
    // token不为空，检查token正确性
    if (token != null) {
      try {
        // 检查token
        Result<dynamic> check = await HttpUtil.post('/accesstoken', data: { 'accesstoken': token });
        // 请求检查成功
        if (check.response.statusCode == 200 && check.success) {
          // 请求中设置默认携带token进行请求
          HttpUtil.setDefaultParams({ Config.TOKEN_REQUEST_PARAM_KEY: token });
          // 存储用户名
          String name = check.response.data['loginname'];
          // 存入到mobx
          userStore.setInfo(token, name, check.response.data['avatar_url']);
          // 初始化收藏的话题
          _initCollect(name);
        } else {
          // token错误，清空缓存，相当于自动退出
          prefs.clear();
        }
      } catch (e) {
        // 校验错误，清空缓存
        prefs.clear();
      }
    } else {
      // token不存在，清空缓存
      prefs.clear();
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
