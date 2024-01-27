import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendify/models/friendsModel.dart';

class FriendService {
  final CollectionReference friendsCollection =
      FirebaseFirestore.instance.collection('friends');

  Future<List<Friend>> getAllFriends(String userEmail) async {
    QuerySnapshot<Map<String, dynamic>> friendsSnapshot =
        await friendsCollection.where('friendOf', isEqualTo: userEmail).get()
            as QuerySnapshot<Map<String, dynamic>>; // Explicit type cast

    return friendsSnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic> data = doc.data()!;
          return Friend.fromFirestore(data);
        })
        .toList();
  }

  Future<void> addFriend(String userEmail, Friend friend) async {
    await friendsCollection.add({
      'friendOf': userEmail,
      'friendData': friend.toMap(),
    });
  }
}
