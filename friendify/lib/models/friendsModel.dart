class Friend {
  final String name;
  final String email;
  final String profilePictureUrl; 
  final String friendOf;

  Friend({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.friendOf,
  });


    factory Friend.fromFirestore(Map<String, dynamic> data) {
    Map<String, dynamic> friendData = data['friendData'] ?? {};

    return Friend(
      name: friendData['name'] ?? '',
      email: friendData['email'] ?? '',
      friendOf: friendData['friendOf'] ?? '',
      profilePictureUrl: friendData['profilePictureUrl'] ?? '',
    );
  }

  // Here I convert Friend instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      "friendOf":friendOf,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
