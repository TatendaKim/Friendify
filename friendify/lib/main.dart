import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friendify/views/globalUsers.dart';
import 'package:friendify/views/loginSIgnup.dart';
import 'package:friendify/views/userProfile.dart';
import 'firebase_options.dart';
Future<void> main() async{

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendily App',
      debugShowCheckedModeBanner: false,
      
      home:  UserProfileScreen(),
    );
  }
}
