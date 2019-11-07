import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/avatar.dart';
import '../models/user.dart';
import './image_preview.dart';

class UserInfo extends StatelessWidget {

  final User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 26),
              child: user.avatarUrl != null ? GestureDetector(
                onTap: () {
                  _imagePreview(user.avatarUrl, context);
                },
                child: Avatar(user.avatarUrl, size: 80),
              ) : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.strikethrough_s, color: Colors.white, size: 18),
                        Text('${user.score} 积分   ', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _openGitHub,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('  '),
                          Image.asset('assets/icons/github.png', width: 16, height: 16),
                          Text(' @${user.loginname}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text('注册时间 ${user.createAt}', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  // url点击处理，浏览器中打开个人github
  void _openGitHub() async {
    String url = 'https://github.com/${user.githubUsername}';
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