import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {

  final ImageProvider imageProvider;

  ImagePreview(this.imageProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: PhotoView(
                  imageProvider: imageProvider,
                ),
              ),
              Positioned(//右上角关闭按钮
                right: 10,
                top: MediaQuery.of(context).padding.top,
                child: Icon(Icons.close,size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page}) : super(
		pageBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
		) => page,
    transitionsBuilder: (
			BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
			Widget child,
		) => FadeTransition(
			opacity: animation,
			child: child,
		),
	);
}