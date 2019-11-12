import 'package:flutter/material.dart';
import '../utils/http_util.dart';
import '../models/article.dart';
import '../models/reply.dart';
import '../components/article_detail.dart';
import '../components/reply_item.dart';

class ArticlePage extends StatefulWidget {
  final String id;
  final String title;

  ArticlePage(this.id, this.title, { Key key }) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  // 文章详情
  Article _article;
  // 评论列表数据
  List<dynamic> _list = [];
  // 滚动控制器
  ScrollController _scrollController = ScrollController();
  // 是否显示返回顶部按钮
  bool _showToTop = false;

  @override
  void initState() {
    super.initState();
    // 获取数据
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: Container(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _article != null ? _list.length + 2 : 1, // 第0个存放文章内容，第1个为评论标题，如果数据未加载完为1，否则会出现两个加载中提示
            itemBuilder: (BuildContext content, int index) {
              if (_article != null) {
                if (index == 0) {
                  return ArticleDetail(_article);
                } else if (index == 1) {
                  return Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${_list.length}',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(
                              ' 回复',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 96,
                          height: 30,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Text('添加回复'),
                            color: Colors.white,
                            textColor: Colors.blue,
                            borderSide: BorderSide(width: 1, color: Colors.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // 渲染item，索引0位文章内容，索引1为评论标题，评论索引从2开始
                  return ReplyItem(Reply.fromJson(_list[index - 2] as Map<String, dynamic>), index - 1);
                }
              } else {
                // 请求未结束，显示loading
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    '正在加载···',
                    style: TextStyle(color: Colors.black45),
                  ),
                );
              }
            },
          ),
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
    Result<Map<String, dynamic>> result = await HttpUtil.get('/topic/${widget.id}');
    setState(() {
      _article = Article.fromJson(result.data);
      _list = result.data['replies'] as List<dynamic>;
    });
  }
}