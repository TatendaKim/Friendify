import 'package:flutter/material.dart';
import 'package:friendify/views/userProfile.dart';

class FriendsScreen extends StatelessWidget {
  final List<String> friendsList = [
    'Tatenda Kim',
    'Lloyd Ndhlovu',
    'Sean Davis',
    // Add more friends as needed
  ];

  final String userProfilePictureUrl = 'assets/user1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Friends', style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.bold,)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage(userProfilePictureUrl),
            radius: 20, // Adjust radius as needed
          ),
          const SizedBox(width: 20), // Add spacing between avatar and other actions
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
                return FriendListItem(
                  friendName: friendsList[index],
                  onTap: () {
                    // Handle friend list item tap if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final String friendName;
  final VoidCallback onTap;

  FriendListItem({required this.friendName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // Replace with profile photo
        backgroundColor: Colors.grey,
        child: Text(friendName[0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      title: Text(friendName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          minimumSize: const Size(100, 40), // Adjust width as needed
        ),
        child: const Text('Friend', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
      onTap: onTap,
    );
  }
}
