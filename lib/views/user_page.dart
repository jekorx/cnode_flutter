import 'package:flutter/material.dart';
import '../utils/http_util.dart';
import '../components/user_info.dart';
import '../components/personal_topics.dart';
import '../models/author.dart';
import '../models/user.dart';

class UserPage extends StatefulWidget {

  final Author author;

  UserPage(this.author, { Key key }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
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
      body: RefreshIndicator(
        onRefresh: _getData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: _user != null ? 250 : 0,
              title: Padding(
                padding: EdgeInsets.only(right: 56),
                child: Center(
                  child: Text(widget.author.loginname),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue],
                    ),
                  ),
                  child: _user != null ? UserInfo(_user) : null,
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs.map((String tab) => Tab(text: tab)).toList(),
              ),
            ),
            PersonalTopics(_tabList, _tabIndex),
          ],
        ),
      ),
      floatingActionButton: _showToTop ? FloatingActionButton(
        onPressed: _toTop,
        tooltip: '返回顶部',
        child: Icon(Icons.arrow_upward),
      ) : null,
    );
  }

  // 返回顶部
  void _toTop() {
    // 动画滚动到顶部，如果滚动到顶部位置为0会触发下拉刷新
    _scrollController.animateTo(0.1, duration: Duration(milliseconds: 800), curve: Curves.ease);
  }

  // 获取数据
  Future<void> _getData() async {
    Result<Map<String, dynamic>> result = await HttpUtil.get('/user/${widget.author.loginname}');
    Result<dynamic> collect = await HttpUtil.get('/topic_collect/${widget.author.loginname}', data: { 'mdrender': false });
    Map<String, dynamic> user = result.data;
    setState(() {
      _user = User.fromJson(user);
      _tabList[0] = user['recent_topics'];
      _tabList[1] = user['recent_replies'];
      _tabList[2] = collect.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }
}