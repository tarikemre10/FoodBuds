import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/repositories/chat_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_page.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';

class DateMenuPage extends StatelessWidget {
  final Restaurant restaurant;
  final String receiverId;
  final String name;
  final String imageUrl;

  const DateMenuPage({
    super.key,
    required this.restaurant,
    required this.receiverId,
    required this.name,
    required this.imageUrl,
  });

  Future<void> sendDateMessage() async {
    await ChatRepository().sendDatingMessage(receiverId, restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
          ),
        backgroundColor: Colors.white,
        title: const Text(
          '    Ask For Date',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28),
        ), 
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ // Adds space above the image
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        restaurant.filePath ?? 'images/default.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      restaurant.restaurantName ?? 'Default Restaurant Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${restaurant.cuisineType} - Rating: ${restaurant.rating} ⭐',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Location: ${restaurant.location}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Closes at: ${restaurant.closingHour}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  sendDateMessage();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                        name: name, imageUrl: imageUrl, receiverId: receiverId),
                  ));
                },
                child: Text(
                  'ASK FOR A DATE',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
