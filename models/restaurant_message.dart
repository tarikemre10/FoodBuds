import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbuds0_1/models/chat_model.dart';

class RestaurantMessage extends Message {
  final String restaurantName;
  final String location;
  final String cuisineType;
  final String rating;
  final String filePath;
  final String closingHour;

  const RestaurantMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required Timestamp timestamp,
    required String message,
    required this.restaurantName,
    required this.location,
    required this.cuisineType,
    required this.rating,
    required this.filePath,
    required this.closingHour,
  }) : super(
          senderId: senderId,
          senderName: senderName,
          receiverId: receiverId,
          timestamp: timestamp,
          message: message,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'message': message,
      'restaurantName': restaurantName,
      'location': location,
      'cuisineType': cuisineType,
      'rating': rating,
      'filePath': filePath,
      'closingHour': closingHour,
    };
  }
}
