import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:friendify/controllers/userProfileCrud.dart';
import 'package:friendify/models/userProfile.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  // The current user
  User? get currentUser => _auth.currentUser;
  
  // Register with email and password
  Future<User?> signUp(
      {required String fullname,
      required String email,
      required String password,
      required File imageUrl,
      }) async {
    try {
      print("Im inside google sign up");
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();    
      

      String imageDownloadUrl = await uploadImageToStorage(userCredential.user!.uid, imageUrl);
     
      UserProfile userProfile = UserProfile(name: fullname, email: email, profilePicture: imageDownloadUrl);
      await UserProfileCrud().createUser(userProfile);
      
      // Return the newly registered user
      return userCredential.user; 
    } on FirebaseAuthException catch (e) {
      print(e);
      return null; 
    }

       }

  // Sign in with email and password
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // If successful sign-in, return the user
      return userCredential.user; 
    } on FirebaseAuthException catch (e) {
      return null; 
    }
  }
  }


 // Uploading image to Firebase Storage
  Future<String> uploadImageToStorage(String userId, File imageFile) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('user_profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
