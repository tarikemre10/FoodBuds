import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/chat_model.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/models/restaurant_message.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';

class ChatRepository extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String? currentUserId = await AuthenticationRepository().getUserId();
    final User currentUserData =
        await DatabaseRepository().getUser(currentUserId as String).first;
    final String currentUserName = currentUserData.name;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderName: currentUserName,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<void> sendDatingMessage(String receiverId, Restaurant restaurant) async {
    final String? currentUserId = await AuthenticationRepository().getUserId();
    final User currentUserData =
        await DatabaseRepository().getUser(currentUserId as String).first;
    final String currentUserName = currentUserData.name;
    final Timestamp timestamp = Timestamp.now();

    RestaurantMessage newMessage = RestaurantMessage(
      senderId: currentUserId,
      senderName: currentUserName,
      receiverId: receiverId,
      timestamp: timestamp,
      message: "Hey! I want to go on a date with you at ${restaurant.restaurantName}",
      restaurantName: restaurant.restaurantName,
      location: restaurant.location,
      cuisineType: restaurant.cuisineType,
      rating: restaurant.rating,
      filePath: restaurant.filePath ?? 'images/default_restaurant.png',
      closingHour: restaurant.closingHour,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<void> createMessageRoom(String receiverId) async {
    final String? currentUserId = await AuthenticationRepository().getUserId();
    final User currentUserData =
        await DatabaseRepository().getUser(currentUserId as String).first;
    final String currentUserName = currentUserData.name;

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Create chat room document with metadata
    await _fireStore.collection('chat_rooms').doc(chatRoomId).set({
      'users': ids,
      'created_at': Timestamp.now(),
      'last_message': '',
      // Add other fields if necessary
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String otherUserId) async* {
    String userId = await AuthenticationRepository().getUserId() as String;
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    yield* _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<List<ChatRoom>> getChatRooms() async* {
    // Fetch the current user ID
    String userId = await AuthenticationRepository().getUserId() as String;

    // Query chat rooms where the user is a participant
    Stream<QuerySnapshot> chatRoomsStream =
        FirebaseFirestore.instance.collection('chat_rooms').snapshots();
    print("Current user ID: $userId");

    // Transform the stream of QuerySnapshot to a stream of List<ChatRoom>
    yield* chatRoomsStream.map((snapshot) {
      print("Number of documents in snapshot: ${snapshot.docs.length}");

      return snapshot.docs.where((doc) {
        // Extract the user IDs from the document ID
        List<String> ids = doc.id.split('_');
        print("Document ID: ${doc.id}, Extracted IDs: $ids");

        bool containsUser = ids.contains(userId);
        print("Does the document contain the user ID? $containsUser");
        return containsUser;
      }).map((doc) {
        print("Creating ChatRoom widget for document ID: ${doc.id}");
        return ChatRoom(
          senderName:
              "höö", // Placeholder for senderName, replace with actual value if needed
          userIds: doc.id.split('_'),
        );
      }).toList();
    });
  }
}
