import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbuds0_1/models/restaurant_message.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/ui/home_screens/home_screens.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String receiverId;

  const ChatDetailPage({
    required this.name,
    required this.imageUrl,
    required this.receiverId,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  String? senderId;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      senderId = await AuthenticationRepository().getUserId() as String;
    } catch (error) {
      print(error);
    }
  }

  void _handleSend() async {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text;
      _controller.clear(); // Clear the text field
      await ChatRepository().sendMessage(widget.receiverId, message);
    }
  }

  Stream<QuerySnapshot> _messageStream() {
    try {
      return ChatRepository().getMessages(widget.receiverId)
          as Stream<QuerySnapshot>;
    } catch (err) {
      print(err);
      return Stream<QuerySnapshot>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
          ),
          title: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  // Fetch user details from Firestore or any data source
                  DocumentSnapshot userSnapshot = await FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(widget.receiverId)
                      .get();
                  User user = User.fromSnapshot(userSnapshot);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileDetail(user: user),
                  ));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RestaurantSelectionPage(
                      receiverId: widget.receiverId,
                      name: widget.name,
                      imageUrl: widget.imageUrl),
                ));
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _messageStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No messages yet."));
                    }

                    var messages = snapshot.data!.docs.map((doc) {
                      try {
                        if (doc['restaurantName'] != null) {
                          return RestaurantMessage(
                            senderId: doc['senderId'],
                            senderName: doc['senderName'],
                            receiverId: doc['receiverId'],
                            timestamp: doc['timestamp'],
                            message: doc['message'],
                            restaurantName: doc['restaurantName'],
                            location: doc['location'],
                            cuisineType: doc['cuisineType'],
                            rating: doc['rating'],
                            filePath: doc['filePath'],
                            closingHour: doc['closingHour'],
                          );
                        } else {
                          return Message(
                            senderId: doc['senderId'],
                            senderName: doc['senderName'],
                            receiverId: doc['receiverId'],
                            timestamp: doc['timestamp'],
                            message: doc['message'],
                          );
                        }
                      } catch (e) {
                        return Message(
                          senderId: doc['senderId'],
                          senderName: doc['senderName'],
                          receiverId: doc['receiverId'],
                          timestamp: doc['timestamp'],
                          message: doc['message'],
                        );
                      }
                    }).toList();

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        bool isMe = message.senderId == senderId;
                        if (message is RestaurantMessage) {
                          return MessageBubble(
                            isMe: isMe,
                            text: message.message,
                            time: message.timestamp.toDate().toString(),
                            isRestaurantMessage: true,
                            restaurant: Restaurant(
                              restaurantName: message.restaurantName,
                              location: message.location,
                              cuisineType: message.cuisineType,
                              rating: message.rating,
                              filePath: message.filePath,
                              closingHour: message.closingHour,
                            ),
                          );
                        } else {
                          return MessageBubble(
                            isMe: isMe,
                            text: message.message,
                            time: message.timestamp.toDate().toString(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ChatInputField(
                  controller: _controller,
                  onSend: _handleSend,
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;
  final bool isRestaurantMessage;
  final Restaurant? restaurant;

  const MessageBubble({
    required this.isMe,
    required this.text,
    required this.time,
    this.isRestaurantMessage = false,
    this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: screenWidth * 0.75,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: isRestaurantMessage && restaurant != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant!.restaurantName,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Image.asset(
                    restaurant!.filePath ?? 'images/default_restaurant.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Location: ${restaurant!.location}',
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Cuisine: ${restaurant!.cuisineType}',
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Rating: ${restaurant!.rating}',
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Closing Hour: ${restaurant!.closingHour}',
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    time.split(' ')[1].substring(0, 5),
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    time.split(' ')[1].substring(0, 5),
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}


class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Type Something...',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              fillColor: Colors.grey[200],
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            ),
          ),
        ),
        Container(
          height: 60,
          width: 70,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: onSend,
          ),
        ),
      ],
    );
  }
}
