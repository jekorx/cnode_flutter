# cnode_flutter

- flutter 学习

CNodejs flutter实现，可在CNodejs社区注册账号，使用AccessToken登录。[https://cnodejs.org](https://cnodejs.org)

> 当前功能
> - 首页列表，下拉刷新，上拉加载更多，返回顶部
> - 类型列表，下拉刷新，上拉加载更多，返回顶部
> - 个人中心，最新创建列表，最近参与列表，收藏列表，返回顶部，退出、登录，跳转github网页，头像预览
> - 文章详情，评论列表，返回顶部，点击用户头像查看用户信息，收藏，取消收藏，富文本网页链接跳转，图片预览
> - 个人信息，最新创建列表，最近参与列表，收藏列表，头像预览，返回顶部，跳转github网页

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# build_runner
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch --delete-conflicting-outputs
```