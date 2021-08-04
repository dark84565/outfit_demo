import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outfit2/Database/Constants.dart';

class DatabaseMethods {
  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.userId)
        .set(userData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addFavoriteSamples(sampleData) async {
    var nowTime = DateTime.now();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.userId)
        .collection("favoriteSamples")
        .doc(nowTime.toString())
        .set(sampleData)
        .catchError((e) {
      print(e);
    });
  }

  getFavoriteSamples() async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.userId)
        .collection("favoriteSamples")
        .snapshots();
  }

  determineFavoriteSamples(String imageUrl) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.userId)
        .collection("favoriteSamples")
        .where("imageUrl", isEqualTo: imageUrl)
        .get();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadGratitude(gratitudeMap, String timeAndDate) {
    //上傳至firestore
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Constants.userId)
        .collection("GratitudeList")
        .doc(timeAndDate)
        .set(gratitudeMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getMCategoriesData() async {
    return FirebaseFirestore.instance.collection("MOutfit").snapshots();
  }

  getMSamplesData(int index) async {
    switch (index) {
      case 0:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("古著")
            .collection("picture")
            .snapshots();
      case 1:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("日系")
            .collection("picture")
            .snapshots();
      case 2:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("街頭")
            .collection("picture")
            .snapshots();
      case 3:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("韓系")
            .collection("picture")
            .snapshots();
    }
  }

  getCategoryListData() async {
    return FirebaseFirestore.instance.collection("Outfit").snapshots();
  }

  getSamplesStyleListData(int index) async {
    switch (index) {
      case 0:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("古著")
            .collection("picture")
            .snapshots();
      case 1:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("工裝")
            .collection("picture")
            .snapshots();
      case 2:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("街頭")
            .collection("picture")
            .snapshots();
      case 3:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("韓系")
            .collection("picture")
            .snapshots();
    }
  }

  ///用get才能取result.documents.length
  getSamplesStyleListLength(int index) async {
    switch (index) {
      case 0:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("古著")
            .collection("picture")
            .get();
      case 1:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("工裝")
            .collection("picture")
            .get();
      case 2:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("街頭")
            .collection("picture")
            .get();
      case 3:
        return FirebaseFirestore.instance
            .collection("Outfit")
            .doc("韓系")
            .collection("picture")
            .get();
    }
  }

  getUsersData(int limit) async {
    return FirebaseFirestore.instance
        .collection('Users')
        .limit(limit)
        .snapshots();
  }

  getMessageList(String userId, String groupChatId, int limit) async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('contactUsers')
        .doc(groupChatId)
        .collection(groupChatId).limit(limit)
        .snapshots();
  }

  saveMessage(String userId, String groupChatId, Map data) async {
    var nowTime = DateTime.now();
    var documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('contactUsers')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(nowTime.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, data);
    });
  }

  createChatRoom(String chatRoomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
