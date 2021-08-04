import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:outfit2/Auth/RegisterPage.dart';
import 'package:outfit2/Auth/SignInPage.dart';
import 'package:outfit2/Database/Constants.dart';
import 'package:outfit2/Database/Firebase.dart';
import 'package:outfit2/Model/UserModel.dart';

String name;
String email;
String imageUrl;

int loggedInWay = 0;
String userEmail;
String userPassword;

class AuthService extends StatefulWidget {
  @override
  _AuthServiceState createState() => _AuthServiceState();
}

int _index;
int count = 8;
int counter;

class _AuthServiceState extends State<AuthService> {
  Stream getImageList;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  PageController _pageController = new PageController();
  Timer _timer;

  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (_pageController.page.round() >= 1) {
        _pageController.jumpToPage(0);
      }
      _pageController.nextPage(
          duration: Duration(seconds: 20), curve: Curves.linear);
    });

  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/跑馬燈.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/跑馬燈.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(150, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          )),
        ),
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              Image.asset(
                'assets/clothes&closer.png',
                width: 250,
                height: 250,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
              ),
              RaisedButton(
                padding: EdgeInsets.all(0),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (BuildContext context, Animation animation,
                          Animation secondaryAnimation) {
                        return new FadeTransition(
                          //漸入
                          opacity: animation,
                          child: RegisterPage(),
                        );
                      },
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 48,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    '註 冊',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: '思源宋體',
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                ),
              ),
              RaisedButton(
                color: Color.fromARGB(0, 0, 0, 0),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  height: 48,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    '登 入',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: '思源宋體',
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
//     }
//   },
// );
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot, index) {
  return Column(
    children: List.generate(count, (index) {
      counter = index;
      _index = (index - 1) % 3;
      print(counter);
      return Image.network(snapshot.data.documents[_index].data()['imageUrl']);
    }),
  );
  // }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

UserID _userFromFirebaseUser(User user) {
  return user != null ? UserID(uid: user.uid) : null;
}

Future<String> signInWithEmailAndPassword(String email, String password) async {
  //取得登入firebase帳戶的userID
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    //利用帳號密碼取得帳戶資料
    User user = result.user;
    // assert(user.email != null);
    // assert(user.displayName != null);
    // assert(user.photoURL != null);
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    return _userFromFirebaseUser(user).uid;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<User> signInWithGoogle(BuildContext context) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  UserCredential result = await _firebaseAuth.signInWithCredential(credential);
  //利用google驗證取得帳戶資料
  User userDetails = result.user;
  assert(userDetails.email != null);
  assert(userDetails.displayName != null);
  assert(userDetails.photoURL != null);

  name = userDetails.displayName;
  email = userDetails.email;
  imageUrl = userDetails.photoURL;

  userEmail = userDetails.email;

  if (result == null) {
  } else {
    Constants.saveUserLoggedInSharedPreference(2);
    Constants.saveUserNameSharedPreference(userDetails.displayName); //轉換字串為小寫
    // Constants.saveUserNameSharedPreference(
    //     userDetails.email.replaceAll("@gmail.com", "").toLowerCase()); //轉換字串為小寫
    Constants.saveUserEmailSharedPreference(userDetails.email);
    Constants.saveUserIdSharedPreference(userDetails.uid);
    // Navigator.pushAndRemoveUntil(
    //     context, MaterialPageRoute(builder: (context) => AccountScreen()), (route) => route == null);
  }
  //於app儲存登入用戶資料
  return userDetails;
}

// sign up with email and password
Future<String> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return _userFromFirebaseUser(user).uid;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

// sign out
Future signOut() async {
  try {
    loggedInWay = 0;
    Constants.saveUserLoggedInSharedPreference(0);
    return await _auth.signOut();
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future resetPass(String email) async {
  try {
    return await _auth.sendPasswordResetEmail(email: email);
  } catch (e) {
    print(e.toString());
    return null;
  }
}
