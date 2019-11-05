import 'package:flutter/material.dart';
import '../utils/http_util.dart';
import '../models/article.dart';
import '../components/list_item.dart';

/// 首页
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    // 初始化加载数据
    _getData();
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
        _getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 4),
        child: RefreshIndicator(
          onRefresh: () => _getData(isReload: true),
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
                    style: TextStyle(color: Colors.black45),
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
  Future<void> _getData({ isReload: false }) async {
    Result<List<dynamic>> result = await HttpUtil.get('/topics', data: {
      'page': isReload ? 1 : _page,
      'limit': 10,
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