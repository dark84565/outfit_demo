import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Database/Constants.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Auth/AuthService.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Database/Firebase.dart';
import 'package:outfit2/main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey formKey = new GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String error = '';

  void showWrongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "請重新輸入！",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text('信箱不符合格式或信箱已註冊',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: '思源宋體',
                fontWeight: FontWeight.w600,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay", style: TextStyle(color: Colors.amber[700])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false, //避免底部overload
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * .1),
          child: Container(
            color: Colors.black,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 10, top: 30, left: 30),
            child: IconButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                        cursorColor: Colors.white,
                        scrollPadding: EdgeInsets.all(100),
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          focusColor: Colors.black,
                          icon: Icon(
                            Icons.mail_outline,
                            size: 30,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          hintText: '電子郵件',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(120, 255, 255, 255),
                            fontSize: 25,
                            fontFamily: '思源宋體',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Email is required' : null,
                        onChanged: (value) {
                          this.email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                        cursorColor: Colors.white,
                        scrollPadding: EdgeInsets.all(100),
                        cursorHeight: 30,
                        obscureText: true,
                        //隱藏正在編輯的文本
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            icon: Icon(
                              Icons.vpn_key,
                              size: 30,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            hintText: '密碼',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(120, 255, 255, 255),
                              fontSize: 25,
                              fontFamily: '思源宋體',
                              fontWeight: FontWeight.w600,
                            ),
                            fillColor: Colors.white),
                        validator: (value) =>
                            value.isEmpty ? 'Password is required' : null,
                        onChanged: (value) {
                          this.password = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: '思源宋體',
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Colors.white,
                        scrollPadding: EdgeInsets.all(100),
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          focusColor: Colors.black,
                          icon: Icon(
                            Icons.drive_file_rename_outline,
                            size: 30,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          hintText: '你的名字',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(120, 255, 255, 255),
                            fontSize: 25,
                            fontFamily: '思源宋體',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Your name is required' : null,
                        onChanged: (value) {
                          this.name = value;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * .7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  height: 45.0,
                  color: Colors.white,
                  child: Text(
                    '註 冊',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: '思源宋體',
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                  onPressed: () async {
                    if ((formKey.currentState as FormState).validate()) {
                      //校正整個form表單的值
                      await signUpWithEmailAndPassword(email, password).then(
                        (value) {
                          Constants.userId = value;
                          if (value != null) {
                            /// uploading user info to Firestore
                            Map<String, String> userInfo = {
                              "userName": name,
                              "email": email,
                            };
                            DatabaseMethods().addData(userInfo);

                            Constants.saveUserLoggedInSharedPreference(1);
                            Constants.saveUserNameSharedPreference(name);
                            Constants.saveUserPasswordSharedPreference(
                                password);
                            Constants.saveUserIdSharedPreference(
                                Constants.userId);
                            Constants.saveUserEmailSharedPreference(email);
                            setState(() {
                              loggedInWay = 1;
                              userEmail = email;
                              userPassword = password;
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyHomePage()),
                                (Route<dynamic> route) => false);
                          } else {
                            setState(
                              () {
                                Constants.saveUserLoggedInSharedPreference(0);
                                error = "please supply a valid/another email";
                                showWrongDialog(context);
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0)
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
            ],
          ),
        ));
  }
}
