import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outfit2/Database/Constants.dart';
import 'package:outfit2/Model/Post.dart';
import 'dart:io';
import 'package:outfit2/SettingPage.dart';
import 'package:sqflite/sqflite.dart';
import '../Database/Firebase.dart';
import 'package:outfit2/Database/Database.dart';
import 'package:outfit2/CollectionPage.dart';
import 'package:outfit2/MyOutfits.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = '';
  Stream getSamplesStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Post> postList;
  Post post;
  int count = 0;

  @override
  void initState() {
    getUserData();
    getFavoriteData();
    getMyOutfitData();
    super.initState();
  }

  getUserData() async {
    Constants.getUserNameSharedPreference().then((value) {
      setState(() {
        username = value;
      });
    });
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

  getMyOutfitData() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Post>> postListFuture = databaseHelper.getPostList();
      postListFuture.then((postList) {
        setState(() {
          this.postList = postList;
          this.count = postList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Constants.userId);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(context),
      body: createListView(context),
    );
  }

  Widget appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                username,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: '思源宋體',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()));
                    })),
          )
        ],
      ),
    );
  }

  Widget createListView(context) {
    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(5),
        childAspectRatio: 3.0 / 3.6,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CollectionPage()));
            },
            child: StreamBuilder(
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
                    else {
                      return Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                if (snapshot.data.documents.length > 0)
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Card(
                                      margin: EdgeInsets.only(right: 2.0),
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft:
                                                  Radius.circular(20.0))),
                                      child: Image.network(
                                        snapshot.data.documents[0]
                                            .data()['imageUrl'],
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (snapshot.data.documents.length == 0)
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Card(
                                        color:
                                            Color.fromARGB(50, 255, 255, 255),
                                        margin: EdgeInsets.only(right: 2.0),
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0))),
                                        child: SizedBox(
                                          height: double.infinity,
                                          width: double.infinity,
                                        )),
                                  ),
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (snapshot.data.documents.length > 1)
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Card(
                                              margin: EdgeInsets.only(
                                                  left: 2.0, bottom: 2.0),
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0))),
                                              child: Image.network(
                                                snapshot.data.documents[1]
                                                    .data()['imageUrl'],
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data.documents.length < 2)
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 2.0, bottom: 2.0),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    50, 255, 255, 255),
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data.documents.length > 2)
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Card(
                                              margin: EdgeInsets.only(
                                                  left: 2.0, top: 2.0),
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20.0))),
                                              child: Image.network(
                                                snapshot.data.documents[2]
                                                    .data()['imageUrl'],
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data.documents.length < 3)
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 2.0, top: 2.0),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    50, 255, 255, 255),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                              child: Text(
                                '穿  搭  收  藏',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: '思源宋體',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                }
              },
            ),
          ),
          Container(),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOutfits()))
                  .then((value) {
                if (value == true) getMyOutfitData();
              });
            },
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      if (count > 0)
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Card(
                            margin: EdgeInsets.only(right: 2.0),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0))),
                            child: Image.file(
                              File(postList[0].picturePath),
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (count == 0)
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Card(
                              color: Color.fromARGB(50, 255, 255, 255),
                              margin: EdgeInsets.only(right: 2.0),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0))),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                              )),
                        ),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (count > 1)
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Card(
                                    margin:
                                        EdgeInsets.only(left: 2.0, bottom: 2.0),
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0))),
                                    child: Image.file(
                                      File(postList[1].picturePath),
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (count < 2)
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 2.0, bottom: 2.0),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(50, 255, 255, 255),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              if (count > 2)
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Card(
                                    margin:
                                        EdgeInsets.only(left: 2.0, top: 2.0),
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.circular(20.0))),
                                    child: Image.file(
                                      File(postList[2].picturePath),
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (count < 3)
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 2.0, top: 2.0),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(50, 255, 255, 255),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ))
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Text(
                      '我  的  穿  搭',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: '思源宋體',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(),
        ]);
  }
}
