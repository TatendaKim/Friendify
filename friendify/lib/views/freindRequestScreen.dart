import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/friendRequestCrud.dart';
import 'package:friendify/controllers/friendsCrud.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/friendRequest.dart';
import 'package:friendify/models/friendsModel.dart';
import 'package:friendify/models/userProfile.dart';
import 'package:friendify/views/navigationBar.dart';
// import 'package:friendify/models/friend_request.dart';
// import 'package:friendify/firebase/friend_request_crud.dart'; // Import your FriendRequestCrud class

class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  FriendRequestCrud friendRequestCrud = FriendRequestCrud();
  List<FriendRequest> friendRequests = []; // Declare the list to hold friend requests

  @override
  void initState() {
    super.initState();
    // Fetch friend requests when the widget is initialized
    getFriendRequests();
  }
 User? currentUser = FirebaseAuth.instance.currentUser;
      
        
  Future<void> getFriendRequests() async {
    // Replace 'current_user_email' with the actual email of the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
    String currentUserEmail = currentUser.email!;
   
    friendRequests = await friendRequestCrud.getFriendRequestsForUser(currentUserEmail);
 }
    // Refresh the UI after obtaining the friend requests
    setState(() {});
  }


Future<void> acceptFriendRequest(FriendRequest friendRequest) async {
  String currentUserEmail = currentUser?.email ?? ''; // Replace '' with the default value

  // Assuming getUserByEmail returns Future<UserProfile?>
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

    // After accepting, you can update the UI or remove the friend request
    // For example, you can remove it from the list and call setState to rebuild the UI
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

        title: Text('Friend Requests'),
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
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    padding: EdgeInsets.all(8),
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
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendRequest.senderName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
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
                // Handle accept button press
                // You can call a function to accept the friend request
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Accept',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // Handle deny button press
                // You can call a function to deny the friend request
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
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
