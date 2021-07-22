import 'dart:async';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outfit2/Database/Constants.dart';
import 'package:outfit2/Database/Firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'FullPhoto.dart';

class ChatRoom extends StatelessWidget {
  final String contactId;
  final String contactPhotoUrl;

  ChatRoom({Key key, @required this.contactId, @required this.contactPhotoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChatScreen(contactId: contactId, contactPhotoUrl: contactPhotoUrl),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactPhotoUrl;

  ChatScreen(
      {Key key, @required this.contactId, @required this.contactPhotoUrl})
      : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(contactId: contactId, contactPhotoUrl: contactPhotoUrl);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(
      {Key key, @required this.contactId, @required this.contactPhotoUrl});

  String contactId;
  String contactPhotoUrl;

  List<QueryDocumentSnapshot> listMessage = new List.from([]); //用於判斷訊息
  int limit = 20;
  int limitIncrement = 20;
  String groupChatId = '';

  File imageFile;
  bool isShowSticker = false;
  bool isLoading = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  Stream messageListStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  _scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        limit += limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if(imageFile != null){
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async{
    String fileName = DateTime.now().toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask

  }

  getMessageList() async {
    databaseMethods
        .getMessageList(Constants.userId, groupChatId, limit)
        .then((value) {
      setState(() {
        messageListStream = value;
      });
    });
  }

  @override
  void initState() {
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    getMessageList();

    super.initState();
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      Map data = {
        'idFrom': Constants.userId,
        'idTo': contactId,
        'timestamp': DateTime.now().toString(),
        'content': content,
        'type': type
      };

      databaseMethods.saveMessage(Constants.userId, groupChatId, data);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(index, snapshot) {
    if (snapshot.data.documents.data()['idFrom' == Constants.userId]) {
      //myMessage (align right)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          snapshot.data.documents.data()['type'] == 0
              ? Container(
            decoration:
            BoxDecoration(color: Color.fromARGB(50, 255, 255, 255)),
            child: Text(
              snapshot.documents.data()['content'],
              style: TextStyle(color: Colors.white),
            ),
          )
              : snapshot.data.documents.data()['type'] == 1
              ? Container(
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            FullPhoto(
                              imageUrl: snapshot.documents
                                  .data()['content'],
                            )));
              },
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                //clipBehavior 裁剪模式:用於子組件大於父組件範圍決定裁剪方式
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: snapshot.documents.data['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  errorWidget: (context, url, error) =>
                      Material(
                        child: Image.asset(
                          'assets/img_not_available.jpeg',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                ),
              ),
            ),
          )
              : Container(
            child: Image.asset(
              'assets/stickers/${snapshot.documents.data()['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          )
        ],
      );
    } else {
      //contactPerson's Message (align left)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isLastMessageLeft(index)
                  ? Material(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: contactPhotoUrl,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(
                        width: 35.0,
                        height: 35.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                ),
              )
                  : Container(width: 35.0),
              snapshot.documents.data()['type'] == 0
                  ? Container(
                width: 200.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(50, 255, 255, 255),
                ),
                child: Text(
                  snapshot.documents.data()['content'],
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : snapshot.documents.data()['type'] == 1
                  ? Container(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullPhoto(
                                    imageUrl: snapshot.documents
                                        .data()['content'])));
                  },
                  child: Material(
                    borderRadius:
                    BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: snapshot.documents.data()['content'],
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          Material(
                            child: Image.asset(
                              'assets/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                    ),
                  ),
                ),
              )
                  : Container(
                child: Image.asset(
                  'assets/stickers/${snapshot.documents.data()['content']}.gif',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          isLastMessageLeft(index)
              ? Container(
            child: Text(DateFormat('dd MMM kk:mm')
                .format(snapshot.documents.data()['timestamp'])),
          )
              : Container()
        ],
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1].data()['idFrom'] == contactId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1].data()['idFrom'] != contactId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildMessageList() {
    return Flexible(
      child: StreamBuilder(
        stream: messageListStream,
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
                listMessage.addAll(snapshot.data.documents);
                return buildItem(context, snapshot);
              }
          }
        },
      ),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mini1', 2),
                child: Image.asset(
                  'assets/stickers/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini2', 2),
                child: Image.asset(
                  'assets/stickers/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini3', 2),
                child: Image.asset(
                  'assets/stickers/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mini4', 2),
                child: Image.asset(
                  'assets/stickers/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini5', 2),
                child: Image.asset(
                  'assets/stickers/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini6', 2),
                child: Image.asset(
                  'assets/stickers/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () => onSendMessage('mini7', 2),
                child: Image.asset(
                  'assets/stickers/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini8', 2),
                child: Image.asset(
                  'assets/stickers/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mini9', 2),
                child: Image.asset(
                  'assets/stickers/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: [
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed:,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMessageList(),
      ],
    );
  }
}
