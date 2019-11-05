import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {

  final String url;
  final double size;

  Avatar(this.url, { this.size = 48 });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black12)),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
    );
  }
}