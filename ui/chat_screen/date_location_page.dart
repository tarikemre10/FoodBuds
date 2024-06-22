import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'package:foodbuds0_1/repositories/restaurant_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';

class RestaurantSelectionPage extends StatefulWidget {
  final String receiverId;
  final String name;
  final String imageUrl;

  const RestaurantSelectionPage({
    super.key,
    required this.receiverId,
    required this.name,
    required this.imageUrl,
  });

  @override
  State<RestaurantSelectionPage> createState() => _RestaurantSelectionPageState();
}

class _RestaurantSelectionPageState extends State<RestaurantSelectionPage> {
  Restaurant? selectedRestaurant;

  final List<Restaurant> restaurants = RestaurantRepository().getRestaurants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
          ),
        backgroundColor: Colors.white,
        title: Text('Select a Restaurant', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 24)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    var restaurant = restaurants[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRestaurant = restaurant;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                              border: selectedRestaurant == restaurant
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    restaurant.filePath ?? 'assets/default.jpg',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  restaurant.restaurantName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.green),
                                    SizedBox(width: 5),
                                    Text(
                                      restaurant.closingHour,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.restaurant_menu, color: const Color.fromARGB(255, 255, 0, 0)), // Mutfak tipi için ikon
                                    SizedBox(width: 5),
                                    Text(
                                      restaurant.cuisineType,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.star, color: Color.fromARGB(255, 255, 68, 0)), // Puan için ikon
                                    SizedBox(width: 5),
                                    Text(
                                      restaurant.rating,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.black),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              if (selectedRestaurant != null) ...[
                Text(
                  selectedRestaurant!.restaurantName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
              ],
              ElevatedButton(
                onPressed: () {
                  if (selectedRestaurant == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a restaurant first.'),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DateMenuPage(
                          restaurant: selectedRestaurant!,
                          receiverId: widget.receiverId,
                          name: widget.name,
                          imageUrl: widget.imageUrl,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Select The Restaurant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
