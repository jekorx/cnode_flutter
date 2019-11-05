import 'package:flutter/material.dart';
import '../models/article.dart';
import '../views/article_page.dart';
import './article_title.dart';
import './avatar.dart';

class ListItem extends StatelessWidget {
  // item对象
  final Article _article;
  // 构造函数初始化item对象
  ListItem(this._article);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage(_article.id, _article.title)));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Color(0xffeeeeee))),
        ),
        child: Column(
          children: <Widget>[
            ArticleTitle(_article.title, _article.tab, _article.good, _article.top),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Avatar(_article.author.avatarUrl),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_article.author.loginname),
                              Text(_article.createAt),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.reply, color: Colors.black54, size: 16),
                                  Text(' ${_article.replyCount}  /  '),
                                  Icon(Icons.remove_red_eye, color: Colors.black54, size: 16),
                                  Text(' ${_article.visitCount}'),
                                ],
                              ),
                              Text('最后回复 ${_article.lastReplyAt}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}