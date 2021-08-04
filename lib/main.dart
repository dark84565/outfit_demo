import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outfit2/Auth/AuthService.dart';
import 'package:outfit2/Database/Constants.dart';
import 'package:outfit2/MainPage/HomePage.dart';
import 'package:outfit2/MainPage/SearchPage.dart';
import 'package:outfit2/MainPage/MessagePage.dart';
import 'package:outfit2/MainPage/AccountPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    //重新開啟app讀取原先是否登入
    await Constants.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        loggedInWay = value;
      });
      print(loggedInWay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 0, 0),
      ),
      home: Builder(
        builder: (context) {
          if (loggedInWay == 0) {
            return AuthService();
          } else if (loggedInWay == 1) {
            Constants.getUserEmailSharedPreference().then((value) {
              userEmail = value;
            });
            Constants.getUserPasswordSharedPreference().then((value) {
              userPassword = value;
            });
            Constants.getUserIdSharedPreference().then((value) {
              Constants.userId = value;
            });
            signInWithEmailAndPassword(userEmail, userPassword);
            return MyHomePage();
          } else {
            Constants.getUserIdSharedPreference().then((value) {
              Constants.userId = value;
            });
            signInWithGoogle(context);
            return MyHomePage();
          }
        },
      ),
      debugShowCheckedModeBanner: false, //手機模擬右上圖示關閉
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> viewScreen = [
    HomePage(),
    SearchPage(),
    MessagePage(),
    AccountPage(),
  ];

  int _currentIndex = 0;
  List<int> colorAlpha = [255, 150, 150, 150];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: viewScreen[_currentIndex],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
        ),
        alignment: Alignment.center,
        height: 60,
        width: 240,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Icons.home,
                  color:
                      Color.fromARGB(colorAlpha[0], 255, 255, 255),
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    colorAlpha = [255, 150, 150, 150];
                    _currentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color:
                      Color.fromARGB(colorAlpha[1], 255, 255, 255),
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    colorAlpha = [150, 255, 150, 150];
                    _currentIndex = 1;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.chat,
                  color:
                      Color.fromARGB(colorAlpha[2], 255, 255, 255),
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    colorAlpha = [150, 150, 255, 150];
                    _currentIndex = 2;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.person_rounded,
                  color:
                      Color.fromARGB(colorAlpha[3], 255, 255, 255),
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    colorAlpha = [150, 150, 150, 255];
                    _currentIndex = 3;
                  });
                })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Color.fromARGB(255, 0, 0, 0),
//       ),
//       home: Determine(),
//       debugShowCheckedModeBanner: false, //手機模擬右上圖示關閉
//     );
//   }
// }
//
// class Determine extends StatefulWidget {
//   @override
//   _DetermineState createState() => _DetermineState();
// }
//
// class _DetermineState extends State<Determine> {
//   @override
//   void initState() {
//     getLoggedInState();
//     super.initState();
//   }
//
//   getLoggedInState() async {
//     //重新開啟app讀取原先是否登入
//     await Constants.getUserLoggedInSharedPreference().then((value) {
//       setState(() {
//         loggedInWay = value;
//       });
//       print(loggedInWay);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (loggedInWay == 0) {
//           return SignInPage();
//         } else if (loggedInWay == 1) {
//           Constants.getUserEmailSharedPreference().then((value) {
//             userEmail = value;
//           });
//           Constants.getUserPasswordSharedPreference().then((value) {
//             userPassword = value;
//           });
//           signInWithEmailAndPassword(userEmail, userPassword);
//           return MyHomePage();
//         } else {
//           signInWithGoogle(context);
//           return MyHomePage();
//         }
//       },
//     );
//   }
// }
