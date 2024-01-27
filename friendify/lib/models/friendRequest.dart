import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String senderProfilePic; // Unique ID for the friend request, marked as nullable for Firestore-generated ID
  final String senderEmail; // Email of the user sending the request
  final String senderName;
  final String recipientEmail; // Email of the user receiving the request
  final String status; // Status of the friend request


  FriendRequest({
    required this.senderProfilePic,
    required this.senderEmail,
    required this.recipientEmail,
    required this.status,
    required this.senderName,
  });


  // Create a FriendRequest object from Firestore data
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

  // Convert the FriendRequest object to a Map for Firestore
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