class Friend {
  final String name;
  final String email;
  final String profilePictureUrl; // URL to the profile picture
  final String friendOf;

  Friend({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.friendOf,
  });

  // Factory method to create a Friend instance from Firestore data
  // factory Friend.fromFirestore(Map<String, dynamic> data) {
  //   print('Data from Firestore: $data'); 
  //   return Friend(
  //     name: data['name'] ?? '',
  //     email: data['email'] ?? '',
  //     friendOf: data['friendOf'] ?? '',
  //     profilePictureUrl: data['profilePictureUrl'] ?? '',
  //   );
  // }


    factory Friend.fromFirestore(Map<String, dynamic> data) {
    Map<String, dynamic> friendData = data['friendData'] ?? {};

    return Friend(
      name: friendData['name'] ?? '',
      email: friendData['email'] ?? '',
      friendOf: friendData['friendOf'] ?? '',
      profilePictureUrl: friendData['profilePictureUrl'] ?? '',
    );
  }

  // Convert Friend instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      "friendOf":friendOf,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
