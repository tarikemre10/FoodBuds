import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/home_screens/home_screens.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: GestureDetector(
        onTap: () {
          // Navigate to another page when tapped anywhere on the screen
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                      'images/g45.png'), // Adjust the path to your actual logo image file
                ),
                const SizedBox(height: 20),
                const Text(
                  'WELCOME TO FOODBUD',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                buildAlertTile('BE YOURSELF',
                    'Make sure your photos, age, and bio is true to who you are.'),
                buildAlertTile('BE SAFE',
                    'Don’t be too quick to give out personal information.'),
                buildAlertTile('PLAY IT COOL', 'Treat others with respect.'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAlertTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.warning, color: Colors.red),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(subtitle),
    );
  }
}

// Placeholder for the next page class
class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: const Center(
        child: Text('This is the next page.'),
      ),
    );
  }
}
