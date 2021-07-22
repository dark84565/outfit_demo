import 'package:flutter/material.dart';
import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Auth/AuthService.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    AuthService()),
                (Route<dynamic> route) => false);      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        height: 48,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * .8,
        child: Text(
          '登 出',
          style:
              TextStyle(color: Colors.black, fontFamily: '中特圓體', fontSize: 17),
        ),
      ),
    );
  }
}
