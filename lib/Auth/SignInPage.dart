import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Database/Constants.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Auth/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Database/Firebase.dart';
import 'package:outfit2/main.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey formKey = new GlobalKey<FormState>();
  DatabaseMethods _databaseMethods = DatabaseMethods();
  String email = '';
  String password = '';
  String error = '';

  void showWrongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "帳號或密碼錯誤！",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w600,
            ),
          ),
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
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .1),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 20, top: 40, left: 10),
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
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
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
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
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
                ],
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              minWidth: MediaQuery.of(context).size.width * .7,
              height: 45.0,
              color: Color.fromARGB(150, 255, 255, 255),
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                debugPrint(
                    '....................................................');

                if ((formKey.currentState as FormState).validate()) {
                  //校正整個form表單的值
                  QuerySnapshot userInfoSnapshot =
                      await _databaseMethods.getUserInfo(email);
                  debugPrint(
                      '....................................................');
                  await signInWithEmailAndPassword(email, password).then(
                    (result) {
                      Constants.userId = result;
                      if (result == null) {
                        setState(() {
                          debugPrint(
                              '....................................................');
                          if (userInfoSnapshot.docs[0].data()["userName"] ==
                              null)
                            debugPrint(
                                '....................................................');
                          error = "please supply a valid email";
                          Constants.saveUserLoggedInSharedPreference(0);
                          showWrongDialog(context);
                        });
                      } else {
                        Constants.saveUserLoggedInSharedPreference(1);
                        Constants.saveUserNameSharedPreference(
                            userInfoSnapshot.docs[0].data()["userName"]);
                        Constants.saveUserEmailSharedPreference(email);
                        Constants.saveUserPasswordSharedPreference(password);
                        Constants.saveUserIdSharedPreference(Constants.userId);
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
                      }
                    },
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 45.0,
              minWidth: MediaQuery.of(context).size.width * .7,
              color: Color.fromARGB(255, 66, 103, 178),
              onPressed: () async {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              // borderSide: BorderSide(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/facebook_logo.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Sign in with Facebook',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 45.0,
              minWidth: MediaQuery.of(context).size.width * .7,
              color: Colors.white,
              splashColor: Colors.white,
              onPressed: () async {
                await signInWithGoogle(context).then((value) {
                  ///更新uid以便更改資料庫
                  Constants.userId = value.uid;
                  userEmail = value.email;

                  Map<String, String> userInfo = {
                    "userName": value.displayName,
                    "email": value.email,
                  };
                  DatabaseMethods().addData(userInfo);
                  setState(() {
                    loggedInWay = 2;
                  });
                });

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage()),
                    (Route<dynamic> route) => false);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              // borderSide: BorderSide(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 23.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        '  Sign in with Google  ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom > 0)
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
          ],
        ),
      ),
    );
  }
}
