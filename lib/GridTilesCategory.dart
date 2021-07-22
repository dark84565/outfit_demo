import 'package:flutter/material.dart';
import 'package:outfit2/SamplesStyleList.dart';
import 'package:outfit2/Database/Firebase.dart';

class GridTilesCategory extends StatefulWidget {
  final String imageUrl;
  final int categoryIndex;
  final String type;

  GridTilesCategory(
      {@required this.imageUrl,
      @required this.categoryIndex,
      @required this.type});

  @override
  _GridTilesCategoryState createState() => _GridTilesCategoryState();
}

class _GridTilesCategoryState extends State<GridTilesCategory> {
  int samplesStyleListLength;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            databaseMethods
                .getSamplesStyleListLength(widget.categoryIndex)
                .then((result) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SamplesStyleList(
                          categoryIndex: widget.categoryIndex,
                          type: widget.type,
                          samplesStyleListLength: result.documents.length)));
            });
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.all(5.0),
            child: Image.network(
              "${widget.imageUrl}",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(20, 2, 20, 0),
          child: Text(
            widget.type,
            style:
                TextStyle(color: Colors.white, fontSize: 12, fontFamily: '粗圓體'),
          ),
        ),
      ],
    );
  }
}
