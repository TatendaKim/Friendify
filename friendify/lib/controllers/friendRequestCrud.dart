import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendify/models/friendRequest.dart';

class FriendRequestCrud {
  final CollectionReference friendRequestsCollection =
      FirebaseFirestore.instance.collection('friendRequests');

  Future<void> createRequest({
    required String senderEmail,
    required String senderName,
    required String senderProfilePic,
    required String recipientEmail,
    required String status,
  }) async {

    try {
      // Create a FriendRequest object
      FriendRequest friendRequest = FriendRequest(
        senderEmail: senderEmail,
        recipientEmail: recipientEmail,
        status: status,
        senderProfilePic: senderProfilePic,
        senderName: senderName,
      );
      print(senderProfilePic);

      // Convert the FriendRequest object to a Map
      Map<String, dynamic> requestData = friendRequest.toMap();

      // Add the friend request data to Firestore and let Firebase generate the ID
      await friendRequestsCollection.add(requestData);
    } catch (e) {
      print('Error creating friend request: $e');
    }
  }

   Future<List<FriendRequest>> getFriendRequestsForUser(String userEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await friendRequestsCollection
              .where('recipientEmail', isEqualTo: userEmail)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      List<FriendRequest> friendRequests = querySnapshot.docs
          .map((doc) => FriendRequest.fromFirestore(doc))
          .toList();

      return friendRequests;
    } catch (e) {
      print('Error getting friend requests: $e');
      return [];
    }
  }
}


