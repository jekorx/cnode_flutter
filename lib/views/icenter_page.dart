import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_page.dart';
import '../utils/http_util.dart';
import '../utils/config.dart';
import '../components/user_info.dart';
import '../components/personal_topics.dart';
import '../components/drawer_box.dart';
import '../models/user.dart';
import '../models/topic.dart';
import '../store/user_store.dart';
import '../store/collect_store.dart';

/// 个人中心
class IcenterPage extends StatefulWidget {
  @override
  _IcenterPageState createState() => _IcenterPageState();
}

class _IcenterPageState extends State<IcenterPage> with SingleTickerProviderStateMixin {
  // tab
  final List<String> _tabs = ['最近创建', '最近参与', '收藏'];
  // 存放上述三种类型的列表
  List<List<dynamic>> _tabList = [[], [], []];
  // tab控制器
  TabController _tabController;
  // 默认选项卡索引
  int _tabIndex = 0;
  // 滚动控制器
  ScrollController _scrollController = ScrollController();
  // 是否显示返回顶部按钮
  bool _showToTop = false;
  // 用户信息
  User _user;
  // 显示登录按钮
  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    // 获取数据
    _getData();
    // 初始化tab控制器，并注册监听
    _tabController = TabController(
      initialIndex: _tabIndex,
      length: _tabs.length,
      vsync: this,
    )..addListener(() {
      // 切换类型，滚动到顶部
      _toTop();
      // 设置当前索引
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    // 注册滚动监听
    _scrollController.addListener(() {
      // 显示返回顶部按钮
      if (_scrollController.position.pixels > 200.0 && !_showToTop) {
        setState(() {
          _showToTop = true;
        });
      }
      // 隐藏返回顶部按钮
      if (_scrollController.position.pixels <= 200.0 && _showToTop) {
        setState(() {
          _showToTop = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerBox(_user != null, _logoutHandle),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            leading: Text(''), // 空字符串，覆盖drawer弹出时原有的返回按钮
            pinned: true,
            expandedHeight: _user != null || _showLogin ? 250 : 0,
            title: Center(
              child: Text(_user?.loginname ?? '个人中心'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                  ),
                ),
                child: _user != null ? UserInfo(_user) : Center(
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                        _getData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: Text('立即登录', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabs.map((String tab) => Tab(text: tab)).toList(),
            ),
          ),
          Observer(
            builder: (_) => PersonalTopics(_tabList, _tabIndex, collects: collectStore.collects),
          ),
        ],
      ),
      floatingActionButton: _showToTop ? FloatingActionButton(
        onPressed: _toTop,
        tooltip: '返回顶部',
        child: Icon(Icons.arrow_upward),
      ) : null,
    );
  }

  // 退出登录后操作
  void _logoutHandle() async {
    // 清空缓存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // 删除默认请求参数
    HttpUtil.removeDefaultParams(Config.TOKEN_REQUEST_PARAM_KEY);
    // 清空个人信息store
    userStore.clear();
    // 情况收藏列表store
    collectStore.clear();
    // 清空当前数据
    setState(() {
      _user = null;
      _tabList = [[], [], []];
      _showLogin = true;
    });
  }

  // 返回顶部
  void _toTop() {
    // 动画滚动到顶部，如果滚动到顶部位置为0会触发下拉刷新
    _scrollController.animateTo(0.1, duration: Duration(milliseconds: 800), curve: Curves.ease);
  }

  // 获取数据
  Future<void> _getData() async {
    // 获取token
    String token = userStore.token;
    // token不为空，获取用户信息
    if (token != null && token != '') {
      _getUserInfo(userStore.name);
    } else {
      setState(() {
        _showLogin = true; 
      });
    }
  }

  // 获取用户信息
  Future<void> _getUserInfo(String name) async {
    Result<Map<String, dynamic>> result = await HttpUtil.get('/user/$name');
    Result<List<dynamic>> collect = await HttpUtil.get('/topic_collect/$name', data: { 'mdrender': false });
    Map<String, dynamic> userInfo = result.data;
    User user = User.fromJson(userInfo);
    setState(() {
      _user = user;
      _tabList[0] = userInfo['recent_topics'];
      _tabList[1] = userInfo['recent_replies'];
    });
    collectStore.setAll(collect.data.map((coll) => Topic.fromJson(coll as Map<String, dynamic>)).toList());
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }
}