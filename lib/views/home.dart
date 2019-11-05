import 'package:flutter/material.dart';
import './main_page.dart';
import './type_page.dart';
import './icenter_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 底部tab按钮颜色
  final Color _defaultColor = Colors.grey;
  final Color _activedColor = Colors.blue;
  // 页面索引
  int _currentIndex = 0;
  // 注册页面
  final List<Widget> _pages = [MainPage(), TypePage(), IcenterPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        title: Text('CNodeJs'),
      ) : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('最新', Icons.new_releases, 0),
          _bottomItem('分类', Icons.format_list_bulleted, 1),
          _bottomItem('个人', Icons.person, 2),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index; 
          });
        },
      ),
    );
  }
  // 底部按钮
  BottomNavigationBarItem _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activedColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex != index ? _defaultColor : _activedColor,
        ),
      ),
    );
  }
}
