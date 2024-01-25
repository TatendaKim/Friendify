import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/views/loginSIgnup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Register with email and password
  Future<User?> signUp(
      {required String fullname,
      required String email,
      required String password,
      required String confirmpassword,
      }) async {
    try {
      print("Im inside google sign up");
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();    

      // Update the user's display name
      await userCredential.user?.updateDisplayName(fullname);
      // await UserProfileCrud(uid: userCredential.user?.uid).addUserProfile(
      //   fullname,
      //   "",
      //   "",
      //   "",
      //   "",
      //   false,
      // );
      return userCredential.user; // Return the newly registered user
    } on FirebaseAuthException catch (e) {
      print(e);
      return null; // Return null on error
    }
  }

//   // Sign in with email and password
//   Future<User?> signIn(
//       {required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return userCredential.user; // Successful sign-in, return the user
//     } on FirebaseAuthException catch (e) {
//       return null; // Return null on sign-in error
//     }
//   }

//   // Sign out
//   // Future<void> signOut() async {
//   //   await _auth.signOut();
//   // }

//   Future<void> signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();

//       // Navigate to the login page after sign out
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginSignupScreen()));
//     } catch (e) {
//       // Handle sign-out error
//       print('Error signing out: $e');
//     }
//   }

//   // Check if user is signed in
//   bool isSignedIn() {
//     return _auth.currentUser != null;
//   }

//   //Google sign in
//   // Future<User?> signInwithGoogle() async {
//   //   // begin interactive sign in process
//   //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//   //   //obbtain auth details from request
//   //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//   //   // create a new  credential for user
//   //   final credential = GoogleAuthProvider.credential(
//   //       accessToken: gAuth.accessToken, idToken: gAuth.idToken);

//   //   final UserCredential authResult =
//   //       await _auth.signInWithCredential(credential);
    
//   //   await GoogleSignIn().signOut();
    
//   //   return authResult.user;
//   // }



// final GoogleSignIn _googleSignIn = GoogleSignIn();

// Future<User?> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

//     if (gUser == null) {
//       // User canceled the sign-in process
//        await _googleSignIn.signOut();
//        await _googleSignIn.disconnect();
//       return null;
//     }

//     final GoogleSignInAuthentication gAuth = await gUser.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );

//     final UserCredential authResult = await _auth.signInWithCredential(credential);

//     await _googleSignIn.signOut();
//     await _googleSignIn.disconnect();

//     return authResult.user;
//   } catch (error) {
//     print(error);
//     return null;
//   }
// }



}