// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/friendRequestCrud.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/userProfile.dart';

class UserProfileScreen extends StatefulWidget {

final UserProfile userProfile;
UserProfileScreen({required this.userProfile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
     bool isFriendRequestSent = false;
     
    Future<void> createFriendRequest() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;
        FriendRequestCrud friendRequestCrud = FriendRequestCrud();
        UserProfileCrud userProfileCrud = UserProfileCrud();
        UserProfile? CurrentUserProfile = await userProfileCrud.getUserByEmail(currentUserEmail);
        
        
        await friendRequestCrud.createRequest(
          senderEmail: currentUserEmail,
          recipientEmail: widget.userProfile.email,
          status: 'pending',
          senderName: CurrentUserProfile?.name ?? "", 
          senderProfilePic: CurrentUserProfile?.profilePicture ?? "",
        );

        setState(() {
        isFriendRequestSent = true;
      });
        print('Friend request sent successfully!');
      } else {
        print('Error: Current user is null.');
      }
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration:  BoxDecoration(
              image: DecorationImage(
                image:NetworkImage(widget.userProfile.profilePicture),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    widget.userProfile.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ignore: sized_box_for_whitespace
                 Container(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle follow button press
                        if (!isFriendRequestSent) {
                          createFriendRequest();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            isFriendRequestSent ? Colors.grey : Colors.black,
                        onPrimary: Colors.white,
                      ),
                      child:
                          Text(isFriendRequestSent ? 'Requested' : 'Request'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatCard(title: 'Friends', count: 100),
                              buildStatCard(title: 'Likes', count: 500),
                              buildStatCard(title: 'Posts', count: 200),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard({required String title, required int count}) {
    return Container(
      width: 100,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
