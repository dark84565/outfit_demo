import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outfit2/Database/Database.dart';
import 'package:outfit2/Model/Post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:intl/intl.dart'; //日期套件

class EditPage extends StatefulWidget {
  final File imageFile;
  final Post post;
  final bool isEdited;

  EditPage(
      {@required this.imageFile, @required this.post, @required this.isEdited});

  @override
  _EditPageState createState() => _EditPageState(
        this.imageFile,
        this.post,
        this.isEdited,
      );
}

class _EditPageState extends State<EditPage> {
  TextEditingController introductionController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  FocusNode myFocusNode;
  DatabaseHelper databaseHelper = DatabaseHelper();
  File imageFile;
  Post post;
  bool isEdited;

  _EditPageState(this.imageFile, this.post, this.isEdited);

  void save() async {
    post.date = DateFormat.yMMMd().format(DateTime.now());
    if (post.id != null) {
      await databaseHelper.updateData(post);
    } else {
      await databaseHelper.insertData(post);
    }
  }

  void delete() async {
    await databaseHelper.deleteNote(post.id);
    Navigator.pop(context, true);
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "刪除文件",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "確定要刪除文件嗎？",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "否",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: '思源宋體',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "是",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: '思源宋體',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
                delete();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    introductionController.text = post.introduction;
    remarkController.text = post.remark;
    return Scaffold(
      resizeToAvoidBottomInset: false, //避免底部overload
      backgroundColor: Colors.black,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.file(widget.imageFile, fit: BoxFit.cover),
                  ),
                  if (isEdited)
                    Positioned(
                      child: IconButton(
                        onPressed: () {
                          showDeleteDialog(context);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromARGB(200, 255, 255, 255),
                          size: 35.0,
                        ),
                      ),
                      top: 20.0,
                      right: 20.0,
                    )
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                child: Text(
                  '圖片介紹',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: '思源宋體',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextField(
                  controller: introductionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 255,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: '思源宋體',
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    post.introduction = introductionController.text;
                  },
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                child: Text(
                  '圖片備註',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: '思源宋體',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextField(
                  controller: remarkController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 255,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: '思源宋體',
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    post.remark = remarkController.text;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * .2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    height: 60.0,
                    child: Text(
                      '取 消',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: '思源宋體',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, false);
                    },
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * .2,
                    color: Colors.amber[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    height: 60.0,
                    child: Text(
                      '儲 存',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: '思源宋體',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      if (!isEdited) {
                        final directory =
                            await getApplicationDocumentsDirectory(); //取得目錄
                        final fileName = path.basename(imageFile.path); //取得檔案路徑
                        final savedImage = await imageFile
                            .copy('${directory.path}/$fileName'); //複製檔案
                        post.picturePath = savedImage.path;
                      }
                      save();

                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0)
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
            ],
          ),
        ),
      ),
    );
  }
}
