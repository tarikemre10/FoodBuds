import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'package:foodbuds0_1/ui/profile_creation/alert.dart';

class ShowMeGenderPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ShowMeGenderPage({super.key, required this.data});

  @override
  _ShowMeGenderPageState createState() => _ShowMeGenderPageState();
}

class _ShowMeGenderPageState extends State<ShowMeGenderPage> {
  String? _selectedGender;

  void _handleGenderSelection(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    updateDataToBackend();
  }

  void updateDataToBackend() {
    if (_selectedGender != null) {
      final updatedData = {
        ...widget.data,
        'genderPreference': _selectedGender,
      };
      try {
        DatabaseRepository().updateUser(updatedData);
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Show me', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            genderButton(context, 'Male'),
            SizedBox(height: 16),
            genderButton(context, 'Female'),
            SizedBox(height: 16),
            genderButton(context, 'Everyone'),
          ],
        ),
      ),
    );
  }

  Widget genderButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        _handleGenderSelection(label);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlertPage(),
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Background color
        foregroundColor: Colors.black, // Text color
        minimumSize: Size(200, 50), // Button size
      ),
      child: Text(label),
    );
  }
}
