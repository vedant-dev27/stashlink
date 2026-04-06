import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stashlink/models/list_model.dart';

class FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveBookmark(String uid, ListModel bookmark) async {
    await firestore.collection('bookmarks').add(bookmark.toJson());
  }

  Future<void> delBookmark(
    String uid,
  ) async {}
}
