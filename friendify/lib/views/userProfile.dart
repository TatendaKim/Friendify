import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/main.dart';
import 'package:friendify/views/globalUsers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
// Corrected import statement


class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  

  @override
  void initState() {
    super.initState();
    
  }

 
  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
      //   appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   title: null,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       // Handle back button press
      //     },
      //   ),
      // ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/user2.jpeg'),
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
          
            const SizedBox(height: 8),
            // Bold Heading Text
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
        const Text(
          'Sean Davis', // Replace with the user's name
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 130,
          child: ElevatedButton(
            onPressed: () {
              // Handle follow button press
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black, 
              onPrimary: Colors.white, 
            ),
            child: const Text('Request'),
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
                    //textAlign: TextAlign.justify
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