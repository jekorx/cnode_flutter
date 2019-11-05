import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../views/about_page.dart';

class DrawerBox extends Drawer {

  final List<Map<String, Widget>> _list = [
    { '关于': Icon(Icons.info, color: Color(0xff707070)) },
    { '退出': Image.asset('assets/icons/logout.png', width: 24, height: 24) },
  ];

  final bool isLogin;

  final ValueGetter handle;

  DrawerBox(this.isLogin, this.handle);

  // 重写Drawer中build方法，修改默认宽度
  @override
  Widget build(BuildContext context) {
    // 全面屏顶部
    double paddingTop = MediaQuery.of(context).padding.top;
    assert(debugCheckHasMaterialLocalizations(context));
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: 180),
        child: Material(
          elevation: elevation,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, paddingTop + 10, 10, 20),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ListView(
                    children: _renderList(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderList(BuildContext context) {
    List<Widget> list = _list.asMap().entries.map((MapEntry<int, Map<String, Widget>> entry) {
      int index = entry.key;
      String name = entry.value.keys.first;
      Widget icon = entry.value.values.first;
      return GestureDetector(
        onTap: () {
          _itemClickHandle(context, index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40  ),
          decoration: BoxDecoration(
            border: index > 0 ? Border(top: BorderSide(width: 1, color: Color(0xffeeeeee))) : null,
          ),
          child: Row(
            children: <Widget>[
              icon,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Center(
                    child: Text(name),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    if (!isLogin) {
      list.removeLast();
    }
    return list;
  }

  // 各选项点击处理
  void _itemClickHandle(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
        break;
      case 1:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return Platform.isIOS ? CupertinoAlertDialog(
              title: Text('温馨提示'),
              content: Text('确认退出？'),
              actions: _dialogActions(context, ctx),
            ) : AlertDialog(
              title: Text('温馨提示'),
              content: Text('确认退出？'),
              actions: _dialogActions(context, ctx),
            );
          }
        );
        break;
    }
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
          // 执行回调函数
          handle();
          // 关闭当前提示窗口
          Navigator.of(ctx).pop();
          // 关闭drawer
          Navigator.of(context).pop();
        },
      ),
    ];
  }
}