import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outfit2/CategoryList.dart';

double _animatedHeight = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    void _onclick() {
      setState(() {
        _animatedHeight != 0.0
            ? _animatedHeight = 0.0
            : _animatedHeight = 140.0; //調整下拉高度
      });
    }

    return Column(
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            color: Colors.black87,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
            // width: double.infinity,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.all(0),
                      height: 50,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.5, color: Colors.white),
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: _onclick),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      height: 60,
                      width: 80,
                      alignment: Alignment.center,
                      child: Image(image: AssetImage("assets/clothes&closer.png")),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          margin: EdgeInsets.all(0),
          duration: const Duration(milliseconds: 300),
          height: _animatedHeight,
          width: double.infinity,
          color: Colors.black87,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'S h o p',
                      style: TextStyle(
                          color: Color.fromARGB(245, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'S h o p p i n g      L i s t',
                      style: TextStyle(
                          color: Color.fromARGB(225, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'F a s h i o n      N e w s',
                      style: TextStyle(
                          color: Color.fromARGB(205, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CategoryList(),
        )
      ],
    );
  }
}
