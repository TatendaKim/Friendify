import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String name;
  String email;
  String profilePicture;

  UserProfile({
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  // Converting GlobalUser to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  // I am creating a GlobalUser from Firebase data
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
    );
  }
}
