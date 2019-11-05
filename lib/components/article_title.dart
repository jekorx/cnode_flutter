import 'package:flutter/material.dart';
import './tag.dart';

class ArticleTitle extends StatelessWidget {

  final String title;
  final String tab;
  final bool good;
  final bool top;

  ArticleTitle(this.title, this.tab, this.good, this.top);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Tag(tab, good, top),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17
              ),
            ),
          ),
        ),
      ],
    );
  }
}