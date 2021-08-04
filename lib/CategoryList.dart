import 'package:flutter/material.dart';
import 'package:outfit2/Database/Firebase.dart';
import 'package:outfit2/GridTilesCategory.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryList createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  Stream getCategoryStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  void initState() {
    getImageData();
    super.initState();
  }

  getImageData() async {
    databaseMethods.getCategoryListData().then(
      (result) {
        setState(
          () {
            getCategoryStream = result;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getCategoryStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Text('Error:${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(5),
      childAspectRatio: 3.0 / 4.5,
      children: List<Widget>.generate(
        snapshot.data.documents.length,
        (index) {
          return GridTile(
            child: GridTilesCategory(
              imageUrl: snapshot.data.documents[index].data()['imageUrl'],
              categoryIndex: index,
              type: snapshot.data.documents[index].data()['類型'],
            ),
          );
        },
      ),
    );
  }
}
