import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/profile_creation/kitchen_page.dart';

class DietPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DietPage({super.key, required this.data});

  @override
  _DietDocState createState() => _DietDocState();
}

class _DietDocState extends State<DietPage> {
  String _selectedDiet = '';

  final Map<String, String> _dietIcons = {
    'Herbivore': 'images/Steak.png',
    'Vegetarian': 'images/Eggs.png',
    'Vegan': 'images/Apple.png',
    'Pescatarian': 'images/Fish.png',
    'Flexitarian': 'images/Sashimi.png',
  };

  void _handleDietSelection(String value) {
    setState(() {
      _selectedDiet = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('What do you eat?',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        toolbarHeight: 100.0,
      ),
      body: ListView(
        children: _dietIcons.keys.map((String key) {
          return Card(
            color: _selectedDiet == key ? Colors.green : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(key, style: const TextStyle(color: Colors.black)),
              trailing: Image.asset(_dietIcons[key]!),
              onTap: () {
                _handleDietSelection(key);
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => KitchenPage(
              data: {
                ...widget.data,
                'diet': _selectedDiet,
              },
            ),
          ));
        },
        label: const Text('Continue'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
