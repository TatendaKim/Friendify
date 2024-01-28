import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/friendRequestCrud.dart';
import 'package:friendify/controllers/friendsCrud.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/friendRequest.dart';
import 'package:friendify/models/friendsModel.dart';
import 'package:friendify/models/userProfile.dart';
import 'package:friendify/views/navigationBar.dart';


class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  FriendRequestCrud friendRequestCrud = FriendRequestCrud();
  List<FriendRequest> friendRequests = [];

  @override
  void initState() {
    super.initState();
    // Fetching friend requests when the widget is initialized
    getFriendRequests();
  }
 User? currentUser = FirebaseAuth.instance.currentUser;
      
        
  Future<void> getFriendRequests() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
    String currentUserEmail = currentUser.email!;
   
    friendRequests = await friendRequestCrud.getFriendRequestsForUser(currentUserEmail);
 }
    // Refreshing the UI after obtaining the friend requests
    setState(() {});
  }


Future<void> acceptFriendRequest(FriendRequest friendRequest) async {
  String currentUserEmail = currentUser?.email ?? ''; 

  UserProfile? currentUsersProfile = await UserProfileCrud().getUserByEmail(currentUserEmail);

  if (currentUsersProfile != null) {
    Friend friend = Friend(
      name: friendRequest.senderName,
      profilePictureUrl: friendRequest.senderProfilePic, 
      email: friendRequest.senderEmail,
      friendOf: currentUserEmail,
    );
    
    Friend friend2 = Friend(
      name: currentUsersProfile.name,
      profilePictureUrl: currentUsersProfile.profilePicture, 
      email: currentUsersProfile.email,
      friendOf: friendRequest.senderEmail,
    );

    FriendService friendsCrud = FriendService();
    await friendsCrud.addFriend(currentUserEmail, friend);
    await friendsCrud.addFriend(friendRequest.senderEmail, friend2);

    setState(() {
      friendRequests.remove(friendRequest);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text('Friend Requests'),
      ),
      body: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          return buildFriendRequestCard(friendRequests[index]);
        },
      ),
            bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),

    );
  }

 Widget buildFriendRequestCard(FriendRequest friendRequest) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(friendRequest.senderProfilePic),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendRequest.senderName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sent you a request',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                acceptFriendRequest(friendRequest);
              },
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Deny',
                style: TextStyle(fontSize: 12,color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}

void main() {
  runApp(MaterialApp(
    home: FriendRequestsPage(),
  ));
}
