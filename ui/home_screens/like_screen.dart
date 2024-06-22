import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/user_model.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import '../home_screens/profiledetail_screen.dart'; // Import the ProfileDetail page

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  List<User> _superLikedByUsers = [];
  bool _isLoading = true;
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _fetchSuperLikedByUsers();
  }

  Future<void> _fetchSuperLikedByUsers() async {
    setState(() {
      _isLoading = true;
    });

    String? userId = await AuthenticationRepository().getUserId();
    if (userId != null) {
      List<User> users = await _databaseRepository.getSuperLikedByUsers(userId);
      setState(() {
        _superLikedByUsers = users;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('    Likes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)),
        elevation: 0, // Remove the shadow
      ),
      backgroundColor: Colors.white, // Set the background color of Scaffold to white
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _superLikedByUsers.isEmpty
          ? Center(child: Text('No one is here yet',  style: TextStyle(color: Colors.amber)))
          : Container(
        color: Colors.white, // Set the background color of Container to white
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5, // Adjusted to make images smaller
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: _superLikedByUsers.length,
          itemBuilder: (context, index) {
            User user = _superLikedByUsers[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetail(user: user),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.network(
                    user.filePath ?? 'images/blurred.png',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
