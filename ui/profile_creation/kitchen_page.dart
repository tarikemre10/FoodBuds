import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/profile_creation/profile_creation.dart';

class KitchenPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const KitchenPage({super.key, required this.data});

  @override
  _KitchenState createState() => _KitchenState();
}

class _KitchenState extends State<KitchenPage> {
  Set<String> _selectedCuisines = Set<String>();

  final Map<String, String> _cuisineIcons = {
    'Turkish': 'images/Turkish.png',
    'Italian': 'images/Italian.png',
    'French': 'images/French.png',
    'Chinese': 'images/Chinese.png',
    'Japanese': 'images/Japanese.png',
    'Indian': 'images/Indian.png',
    'Mexican': 'images/Mexican.png',
    'Spanish': 'images/Spanish.png',
    'Thai': 'images/Thai.png',
    'American': 'images/American.png',
  };

  void _handleCuisineSelection(String cuisine) {
    setState(() {
      if (_selectedCuisines.contains(cuisine)) {
        _selectedCuisines.remove(cuisine);
      } else {
        _selectedCuisines.add(cuisine);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Which cuisine do you like?',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        toolbarHeight: 100.0,
      ),
      body: ListView(
        children: _cuisineIcons.keys.map((String cuisine) {
          return Card(
            color: _selectedCuisines.contains(cuisine)
                ? Colors.green
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(cuisine, style: const TextStyle(color: Colors.black)),
              trailing:
                  Image.asset(_cuisineIcons[cuisine]!, width: 35, height: 35),
              onTap: () => _handleCuisineSelection(cuisine),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(widget.data);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowMeGenderPage(
              data: {
                ...widget.data,
                'cuisine': _selectedCuisines.toList(),
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
