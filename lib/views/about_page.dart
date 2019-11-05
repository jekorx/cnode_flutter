import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start  ,
          children: <Widget>[
            Text('基于CNode技术社区api接口，可注册帐号，使用AccessToken登录。'),
            Text('CNodejs api接口公告'),
            Text('update 2019-03-21: 涉及发帖和发评论的接口都已经下线了，太多人为了测试客户端乱发帖了。'),
            Text('受影响功能：'),
            Text('1、发帖'),
            Text('2、回复'),
            Text('3、点赞、取消点赞'),
          ],
        ),
      ),
    );
  }
}