import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import './image_preview.dart';

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
      onImageTap: (src) {
        _imagePreview(src, context);
      },
    );
  }
  
  // url点击处理
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 照片预览
  void _imagePreview(String src, BuildContext context) {
    Navigator.of(context).push(FadeRoute(page: ImagePreview(
      NetworkImage(src)
    )));
  }
}