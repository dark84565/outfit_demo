import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatefulWidget {
  final String imageUrl;

  FullPhoto({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _FullPhotoState createState() => _FullPhotoState();
}

class _FullPhotoState extends State<FullPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //使用photo_view可以觸擊縮放圖片
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.imageUrl),
        ),
      ),
    );
  }
}
