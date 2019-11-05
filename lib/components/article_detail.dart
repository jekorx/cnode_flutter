import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/article.dart';
import '../models/topic.dart';
import './article_title.dart';
import './avatar.dart';
import '../views/login_page.dart';
import './html_rich_text.dart';
import '../views/user_page.dart';
import '../store/collect_store.dart';
import '../utils/http_util.dart';

class ArticleDetail extends StatefulWidget {
  // 文章详情
  final Article article;

  ArticleDetail(this.article, { Key key }) : super(key: key);

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: <Widget>[
          ArticleTitle(widget.article.title, widget.article.tab, widget.article.good, widget.article.top),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage(widget.article.author)));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Avatar(widget.article.author.avatarUrl),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('${widget.article.author.loginname} · 发布于 ${widget.article.createAt}'),
                      Text('来自 ${Article.TAB_MAP[widget.article.tab]} · ${widget.article.visitCount} 次浏览')
                    ],
                  ),
                ),
                Observer(
                  builder: (_) {
                    bool isCollect = collectStore.has(widget.article.id);
                    return SizedBox(
                      width: 70,
                      height: 30,
                      child: RaisedButton(
                        onPressed: _collectHandle,
                        child: Text(isCollect ? '取消' : '收藏'),
                        color: isCollect ? Color(0xffe5e5e5) : Colors.blue,
                        textColor: isCollect ? Color(0xff999999) : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          HtmlRichText(widget.article.content),
        ],
      ),
    );
  }

  // 收藏取消收藏操作
  void _collectHandle() async {
    bool isCollect = collectStore.has(widget.article.id);
    String url;
    String id = widget.article.id;
    // 取消收藏
    if (isCollect) {
      url = '/topic_collect/de_collect';
    } else {
      // 收藏主题
      url = '/topic_collect/collect';
    }
    try {
      Result result = await HttpUtil.post(url, data: { 'topic_id': id });
      if (result.success) {
        if (isCollect) {
          // 取消收藏
          collectStore.remove(id);
          Fluttertoast.showToast(
            msg: '取消收藏',
            gravity: ToastGravity.CENTER
          );
        } else {
          // 收藏主题
          collectStore.add(Topic(
            id: id,
            author: widget.article.author,
            title: widget.article.title,
            lastReplyAt: widget.article.lastReplyAt
          ));
          Fluttertoast.showToast(
            msg: '收藏成功',
            gravity: ToastGravity.CENTER
          );
        }
      }
    } catch (e) {
      _tipLogin();
    }
  }

  // 未登录，提示登录
  void _tipLogin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text('温馨提示'),
          content: Text('您还没有登录，是否前往登录？'),
          actions: _dialogActions(context, ctx),
        ) : AlertDialog(
          title: Text('温馨提示'),
          content: Text('您还没有登录，是否前往登录？'),
          actions: _dialogActions(context, ctx),
        );
      }
    );
  }

  // 提示框按钮，context：Drawer上下文，ctx：AlertDialog上下文
  List<Widget> _dialogActions(BuildContext context, BuildContext ctx) {
    return <Widget>[
      FlatButton(
        child: Text('取消'),
        textColor: Colors.black54,
        onPressed: () {
          // 关闭当前提示窗口
          Navigator.of(ctx).pop();
        },
      ),
      FlatButton(
        child: Text('确认'),
        textColor: Colors.blue,
        onPressed: () {
          // 关闭当前提示窗口
          Navigator.of(ctx).pop();
          // 跳转登录页面
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        },
      ),
    ];
  }
}