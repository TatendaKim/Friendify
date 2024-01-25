import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friendify/views/friendsScreen.dart';
import 'package:friendify/views/globalUsers.dart';
import 'package:friendify/views/loginSIgnup.dart';
import 'package:friendify/views/userProfile.dart';
import 'firebase_options.dart';
Future<void> main() async{

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  // Check if you received the link via `getInitialLink` first
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    // Example of using the dynamic link to push the user to a different screen
   print("HURAAAAAAAAY!!!!!");
  }

  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendily App',
      debugShowCheckedModeBanner: false,
      
      home:  LoginSignupScreen(),
    );
  }
}
