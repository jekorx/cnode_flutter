import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlRichText extends StatelessWidget {
  // 富文本内容
  final String content;
  // 初始化富文本内容
  HtmlRichText(this.content);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      onLinkTap: _launchURL,
    );
  }
  
  // url点击处理
  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}