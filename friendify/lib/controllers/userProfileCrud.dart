import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendify/models/userProfile.dart';

class UserProfileCrud {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserProfile user) async {
    try {
      await usersCollection.doc(user.email).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
    }
  }


  
  Future<UserProfile?> getUserByEmail(String email) async {
    try {
      DocumentSnapshot<Object?> userDoc =
          await usersCollection.doc(email).get();

      if (userDoc.exists) {
        // If the user with the specified email exists, use the fromFirestore factory method
        return UserProfile.fromFirestore(userDoc);
      } else {
        // If no user with the specified email is found, return null
        return null;
      }
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }
}


