import 'package:flutter/material.dart';
import '../utils/http_util.dart';
import '../models/article.dart';
import '../components/list_item.dart';

/// 类型
class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> with SingleTickerProviderStateMixin {
  // 类型map数组
  final List<Map<String, String>> _tabs = [{ 'key': 'good', 'value': '精华' }];
  // 默认选项卡索引
  final int _tabIndex = 0;
  // tab控制器
  TabController _tabController;
  // 当前tab key
  String _currentTab;
  // 列表数据
  List<dynamic> _list = [];
  // 页码
  int _page = 1;
  // 滚动控制器
  ScrollController _scrollController = ScrollController();
  // 是否显示返回顶部按钮
  bool _showToTop = false;
  // 是否末页
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    // 添加普通分类
    _tabs.addAll(Article.TAB_MAP.keys.map((String key) => {
      'key': key,
      'value': Article.TAB_MAP[key],
    }).toList());
    // 初始化tab key
    _currentTab = _tabs[_tabIndex]['key'];
    // 初始化tab控制器，并注册监听
    _tabController = TabController(
      initialIndex: _tabIndex,
      length: _tabs.length,
      vsync: this,
    )..addListener(() {
      // 获取当前tab key
      String tab = _tabs[_tabController.index]['key'];
      // 重新获取数据
      _getData(tab, isReload: true);
      // 保存当前tab key
      setState(() {
        _currentTab = tab;
      });
    });
    // 初始化加载数据
    _getData(_currentTab);
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
      // 滚动到底部加载更多数据
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        _getData(_currentTab);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: _tabs.map((Map<String, String> tab) => Tab(text: tab['value'])).toList(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 4),
        child: RefreshIndicator(
          onRefresh: () => _getData(_currentTab, isReload: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _list.length + 1, // 如果现实加载状态提示，数量需要加1
            itemBuilder: (BuildContext content, int index) {
              if (index == _list.length) {
                // 展示加载状态提示
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    _hasMore ? '正在加载···' : '已加载全部',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                );
              } else {
                // 渲染item
                return ListItem(Article.fromJson(_list[index] as Map<String, dynamic>));
              }
            },
          ),
        ),
      ),
      floatingActionButton: _showToTop ? FloatingActionButton(
        onPressed: _toTop,
        tooltip: '返回顶部',
        child: Icon(Icons.navigation),
      ) : null,
    );
  }
  
  // 返回顶部
  void _toTop() {
    // 动画滚动到顶部，如果滚动到顶部位置为0会触发下拉刷新
    _scrollController.animateTo(0.1, duration: Duration(milliseconds: 800), curve: Curves.ease);
  }

  // 获取数据
  Future<void> _getData(String tab, { isReload: false }) async {
    Result<List<dynamic>> result = await HttpUtil.get('/topics', data: {
      'page': isReload ? 1 : _page,
      'limit': 10,
      'tab': tab,
      'mdrender': false
    });
    List<dynamic> list = result.data;
    setState(() {
      if (list.length > 0) {
        if (isReload) {
          _list = list;
          _page = 1;
        } else {
          _list.addAll(result.data);
          _page++;
        }
      } else {
        _hasMore = false;
      }
    });
  }
}