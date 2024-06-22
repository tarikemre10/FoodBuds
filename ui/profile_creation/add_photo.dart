import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_creation.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  _AddPhotoPageState createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false; // New state variable for loading indicator

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> downloadPhoto() async {
    if (_image != null) {
      try {
        setState(() {
          _isLoading = true; // Turn on loading indicator
        });
        String filePath = await DatabaseRepository().uploadFile(_image!) as String;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DietPage(
            data: {
              ...widget.data,
              'filePath': filePath,
            },
          ),
        ));
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false; // Turn off loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Add a photo for people to see!',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey[400],
                            size: 100,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator() // Show loading indicator when uploading
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                          foregroundColor: Colors.amber, // Text color
                        ),
                        onPressed: downloadPhoto,
                        child:
                            const Text('CONTINUE', style: TextStyle(fontSize: 18.0)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
