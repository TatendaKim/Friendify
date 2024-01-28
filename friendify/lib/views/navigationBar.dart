import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/views/freindRequestScreen.dart';
import 'package:friendify/views/friendsScreen.dart';
import 'package:friendify/views/globalUsers.dart';
import 'package:friendify/views/loginSIgnup.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => handleNavigation(context, index),
      selectedItemColor: Colors.green, 
      unselectedItemColor: Colors.grey, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
  ),
            
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Friends',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Logout',
        ),

      ],
    );
  }

  void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Home Screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GlobalUsersPage()));
        break;
      case 1:
        // Friends Screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FriendsScreen()));
        break;
      case 2:
        // Notifications Screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FriendRequestsPage()));
        break;
      case 3:
        // Logout
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));

        break;
    }
  }
}
