import 'package:flutter/material.dart';
import 'package:outfit2/Database/Firebase.dart';
import 'package:outfit2/GridTileSampleStyleList.dart';
import 'package:outfit2/SamplesDetails.dart';

class SamplesStyleList extends StatefulWidget {
  final int categoryIndex;
  final String type;
  final int samplesStyleListLength;

  SamplesStyleList(
      {Key key, this.categoryIndex, this.type, this.samplesStyleListLength})
      : super(key: key);

  @override
  _SamplesStyleListState createState() => _SamplesStyleListState();
}

class _SamplesStyleListState extends State<SamplesStyleList>
    with TickerProviderStateMixin {
  Stream getSampleStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Animate animate;
  AnimationController animationController;
  Animation animationHold;
  Animation animationAppear;
  Animation animationDisappear;
  var _animate = new List<Animate>();

  @override
  void initState() {
    getImageData();
    displayAnimation();
    super.initState();
  }

  getImageData() async {
    databaseMethods
        .getSamplesStyleListData(widget.categoryIndex)
        .then((result) {
      setState(() {
        getSampleStream = result;
      });
    });
  }

  displayAnimation() {
    for (int i = 0; i < widget.samplesStyleListLength; i++) {
      ///需initial每個controller
      animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500),
      );

      animationAppear = CurvedAnimation(
          parent: animationController,
          curve: Interval(0.0, 0.6, curve: Curves.bounceOut));
      animationAppear = Tween(begin: 0.0, end: 40.0).animate(animationAppear);

      animationHold = CurvedAnimation(
          parent: animationController,
          curve: Interval(0.6, 0.9, curve: Curves.bounceOut));
      animationHold = Tween(begin: 0.0, end: 0.0).animate(animationHold);

      animationDisappear = CurvedAnimation(
          parent: animationController,
          curve: Interval(0.9, 1.0, curve: Curves.easeInCubic));
      animationDisappear =
          Tween(begin: 0.0, end: -40.0).animate(animationDisappear);

      animate = Animate(animationController, animationHold, animationAppear,
          animationDisappear);

      _animate.add(animate);

      _animate[i].animationController.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.samplesStyleListLength; i++) {
      _animate[i].animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.type,
          style:
              TextStyle(fontSize: 18, fontFamily: '粗圓體', color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: StreamBuilder(
        stream: getSampleStream,
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
              else
                return createListView(context, snapshot);
          }
        },
      ),
    );
  }

  Widget createListView(context, snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(1.0),
      childAspectRatio: 3.0 / 4.0,
      children: List<Widget>.generate(snapshot.data.documents.length, (index) {
        return GridTile(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint(index.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SamplesDetails(
                              sampleIndex: index,
                              categoryIndex: widget.categoryIndex)));
                },
                onDoubleTap: () {
                  _animate[index].animationController.forward().then((value) {
                    _animate[index].animationController.reset();
                  });
                  databaseMethods
                      .determineFavoriteSamples(
                          snapshot.data.documents[index].data()['imageUrl'])
                      .then((result) {
                    if (result.documents.length == 0) {
                      Map<String, String> sampleInfo = {
                        "imageUrl":
                            snapshot.data.documents[index].data()['imageUrl'],
                        "narrative":
                            snapshot.data.documents[index].data()['narrative'],
                      };
                      DatabaseMethods().addFavoriteSamples(sampleInfo);
                    }
                  });
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.all(5.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: index,
                        child: Image.network(
                          snapshot.data.documents[index].data()['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: _animate[index].animationAppear.value +
                            _animate[index].animationDisappear.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ), // child: GridTileSampleStyleList(
          //     imageUrl: snapshot.data.documents[index]
          //         .data()['imageUrl'],
          //     narrative: snapshot.data.documents[index]
          //         .data()['narrative'],
          //     categoryIndex: widget.categoryIndex,
          //     sampleIndex: index),
        );
      }),
    );
  }
}

class Animate {
  AnimationController animationController;
  Animation animationHold;
  Animation animationAppear;
  Animation animationDisappear;

  ///constructor is very important
  Animate(AnimationController animationController, Animation animationHold,
      Animation animationAppear, Animation animationDisappear) {
    this.animationController = animationController;
    this.animationHold = animationHold;
    this.animationAppear = animationAppear;
    this.animationDisappear = animationDisappear;
  }
}
