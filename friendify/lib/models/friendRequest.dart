import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String senderProfilePic; // Unique ID for the friend request, marked as nullable for Firestore-generated ID
  final String senderEmail;
  final String senderName;
  final String recipientEmail; 
  final String status;


  FriendRequest({
    required this.senderProfilePic,
    required this.senderEmail,
    required this.recipientEmail,
    required this.status,
    required this.senderName,
  });


  // Here I am creating a FriendRequest object from Firestore data
  factory FriendRequest.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return FriendRequest(
      senderProfilePic:data['senderProfilePic'],
      senderEmail: data['senderEmail'],
      recipientEmail: data['recipientEmail'],
      status: data['status'],
      senderName: data['senderName'],

    );
  }

  // I then convert the FriendRequest object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderProfilePic':senderProfilePic,
      'senderEmail': senderEmail,
      'recipientEmail': recipientEmail,
      'status': status,
      'senderName':senderName,
    };
  }
}