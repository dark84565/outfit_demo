import 'package:flutter/material.dart';
import 'package:outfit2/Database/Firebase.dart';

class SamplesDetails extends StatefulWidget {
  final int sampleIndex;
  final int categoryIndex;

  SamplesDetails({Key key, this.sampleIndex, this.categoryIndex})
      : super(key: key);

  @override
  _SamplesDetailsState createState() => _SamplesDetailsState();
}

class _SamplesDetailsState extends State<SamplesDetails> {
  Stream getSampleDetailStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  getSampleDetail() async {
    databaseMethods
        .getSamplesStyleListData(widget.categoryIndex)
        .then((result) {
      setState(() {
        getSampleDetailStream = result;
      });
    });
  }

  @override
  void initState() {
    getSampleDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getSampleDetailStream,
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
              return sampleDetails(context, snapshot);
        }
      },
    );
  }

  Widget sampleDetails(context, snapshot) {
    return Column(
      children: [
        Hero(
          tag: widget.sampleIndex,
          child: Image.network(
            snapshot.data.documents[widget.sampleIndex].data()['imageUrl'],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            snapshot.data.documents[widget.sampleIndex].data()['narration'],
            style: TextStyle(
              color: Colors.white,
              fontFamily: '粗圓體',
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
