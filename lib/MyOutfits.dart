import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:outfit2/Model/Post.dart';
import 'package:outfit2/EditPage.dart';
import 'package:outfit2/Database/Database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyOutfits extends StatefulWidget {
  @override
  _MyOutfitsState createState() => _MyOutfitsState();
}

class _MyOutfitsState extends State<MyOutfits> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Post> postList;
  int count = 0;
  Post post;
  bool refreshAccountPage = false;

  void _newPost() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }

    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(
                  imageFile: imageFile,
                  post: Post('', '', '', ''), //須給初始值
                  isEdited: false,
                )));

    if (result == true) {
      refreshAccountPage = true;
      updateListView();
    } else {
      return;
    }
  }

  void updateListView() {
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
    if (postList == null) {
      postList = List<Post>();
      updateListView();
    }
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            '我的穿搭',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: '思源宋體',
                fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, refreshAccountPage);
            },
            icon: Icon(Icons.arrow_back_ios_outlined),
          ),
        ),
        body: count == 0 ? Container() : createListView(context),
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {
              _newPost();
            },
            icon: Icon(Icons.add),
            iconSize: 40.0,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Widget createListView(
    BuildContext context,
  ) {
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPage(
                        imageFile: File(postList[index].picturePath),
                        post: this.postList[index], //須給初始值
                        isEdited: true,
                      )));

          if (result == true) {
            refreshAccountPage = true;
            updateListView();
          } else {
            return;
          }
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.all(5.0),
          child: Image.file(
            File(this.postList[index].picturePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
