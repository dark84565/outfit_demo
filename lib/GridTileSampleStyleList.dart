// import 'package:flutter/material.dart';
// import 'file:///C:/Users/dark8/AndroidStudioProjects/outfit2/lib/Database/Firebase.dart';
//
// class GridTileSampleStyleList extends StatelessWidget {
//   final String imageUrl;
//   final String narrative;
//   final int categoryIndex;
//   final int sampleIndex;
//
//   GridTileSampleStyleList({@required this.imageUrl,
//     @required this.narrative,
//     @required this.categoryIndex,
//     @required this.sampleIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//             onTap: () {
//
//             },
//             onDoubleTap: () {
//               Map<String, String> sampleInfo = {
//                 "imageUrl": imageUrl,
//                 "narrative": narrative,
//               };
//               DatabaseMethods().addFavoriteSamples(sampleInfo);
//             },
//             child: Stack(
//               children: [
//                 Card(
//                   clipBehavior: Clip.antiAlias,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0)),
//                   margin: EdgeInsets.all(5.0),
//                   child: Image.network(
//                     "$imageUrl",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.favorite, color: Colors.redAccent, size:,))
//               ],
//             )
//         ),
//       ],
//     );
//   }
// }
