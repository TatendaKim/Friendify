import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/friendsCrud.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/friendsModel.dart';
import 'package:friendify/models/userProfile.dart';
import 'package:friendify/views/navigationBar.dart';
import 'package:friendify/views/userProfile.dart';


class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Friend> friendsList = [];
  String userProfilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    // Fetching friends data when the screen is initialized
    fetchFriendsData();
  }

  Future<void> fetchFriendsData() async {
    // Using friend service to get friends data
    FriendService friendService = FriendService();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
    String currentUserEmail = currentUser.email!;
   
    List<Friend> friends = await friendService.getAllFriends(currentUserEmail);
     
      //UserProfile for the current user
    UserProfile? currentUserProfile = await UserProfileCrud().getUserByEmail(currentUserEmail);

      // This will Check if the UserProfile is not null and get the profile picture URL
    String profilePictureUrl = currentUserProfile?.profilePicture ?? '';
    setState(() {
      friendsList = friends;
      userProfilePictureUrl=profilePictureUrl;
     
    });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Friends', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // How to navigate back to the previous screen
          },
        ),
        actions: [
          CircleAvatar(
            backgroundImage:NetworkImage(userProfilePictureUrl),
            radius: 20, 
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              
              itemCount: friendsList.length,
              itemBuilder: (context, index) {
                print(friendsList[index].name);
                return FriendListItem(
                  friend: friendsList[index],
                  onTap: () async{

                    UserProfile? currentUserProfile = await UserProfileCrud().getUserByEmail(friendsList[index].email);
                    
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(userProfile: currentUserProfile!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  FriendListItem({required this.friend, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
   
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(friend.profilePictureUrl),
        backgroundColor: Colors.grey,
        radius:25,
      ),
      title: Text(friend.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: ElevatedButton(
        onPressed: () {
        },
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          primary: Colors.black,
          minimumSize: const Size(100, 40),
        ),
        child: const Text('Friend', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
      onTap: onTap,
    );
  }
}