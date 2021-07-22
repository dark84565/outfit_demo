import 'package:flutter/material.dart';
import 'Database/Firebase.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  Stream getSamplesStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  void initState() {
    getFavoriteData();
    super.initState();
  }

  getFavoriteData() async {
    databaseMethods.getFavoriteSamples().then(
      (result) {
        setState(
          () {
            getSamplesStream = result;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '穿搭收藏',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
          stream: getSamplesStream,
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
          }),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(5),
      childAspectRatio: 3.0 / 4,
      children: List<Widget>.generate(
        snapshot.data.documents.length,
        (index) {
          return GridTile(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    margin: EdgeInsets.all(5.0),
                    child: Image.network(
                      snapshot.data.documents[index].data()['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
