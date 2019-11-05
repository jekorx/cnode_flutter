import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../components/avatar.dart';
import '../views/article_page.dart';

class TopicItem extends StatelessWidget {

  final Topic topic;
  final int index;

  TopicItem(this.topic, this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage(topic.id, topic.title)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: index != 0 ? Border(top: BorderSide(width: 1, color: Color(0xffeeeeee))) : null,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                topic.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Avatar(topic.author.avatarUrl),
                    ),
                    Text(topic.author.loginname),
                  ],
                ),
                Text('最后回复 ${topic.lastReplyAt}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}