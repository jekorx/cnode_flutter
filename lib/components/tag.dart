import 'package:flutter/material.dart';
import '../models/article.dart';

class Tag extends StatelessWidget {
  // 类型key
  final String tab;
  // 是否精华
  final bool good;
  // 是否置顶
  final bool top;
  Tag(this.tab, this.good, this.top);

  @override
  Widget build(BuildContext context) {
    String tagTxt = Article.TAB_MAP[tab];
    if (top) tagTxt = '置顶';
    if (good) tagTxt = '精华';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      decoration: BoxDecoration(
        color: (good || top) ? Color(0xff80bd01) : Color(0xffe5e5e5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tagTxt,
        style: TextStyle(
          color: (good || top) ? Colors.white : Color(0xff999999),
        ),
      ),
    );
  }
}