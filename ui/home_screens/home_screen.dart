import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/chat_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'home_screens.dart';
import 'package:foodbuds0_1/models/user_model.dart' as model;
import 'package:foodbuds0_1/repositories/authentication_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomeScreenContent(),
          ChatPage(),
          LikePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.amber,
        color: Colors.amber,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.chat, size: 30, color: Colors.black),
          Icon(Icons.favorite, size: 30, color: Colors.black),
          Icon(Icons.person, size: 30, color: Colors.black),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  double _distance = 5.0;
  String _gender = 'Male';
  RangeValues _ageRange = const RangeValues(22, 34);

  List<model.User> _users = [];
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _superLikeUser(String superLikedUserId) async {
    String? superLikerUserId = await AuthenticationRepository().getUserId();
    if (superLikerUserId != null) {
      await _databaseRepository.superLikeUser(
          superLikerUserId, superLikedUserId);
      await _databaseRepository.likeUser(superLikerUserId, superLikedUserId);
      _showSuperLikeMessage();
      bool isMatch = await _databaseRepository.checkForMatch(
          superLikerUserId, superLikedUserId);
      if (isMatch) {
        ChatRepository().createMessageRoom(superLikedUserId);
        model.User? likedUser =
            await _databaseRepository.getUserById(superLikedUserId);
        model.User? currentUser =
            await _databaseRepository.getUserById(superLikerUserId);
        if (likedUser != null && currentUser != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MatchPage(currentUser: currentUser, likedUser: likedUser),
          ));
        }
      }
    }
  }

  void _showSuperLikeMessage() {
    // Display a message or perform any other action to indicate the super like was successful
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Super Liked!')),
    );

    // Move to the next user
    if (_users.isNotEmpty) {
      setState(() {
        _users.removeAt(0);
      });
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    List<String> userIds = await _databaseRepository.matchUsers();
    List<model.User> users = [];
    for (String userId in userIds) {
      model.User? user = await _databaseRepository.getUserById(userId);
      if (user != null) {
        users.add(user);
      }
    }
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _likeUser(String likedUserId) async {
    String? likerUserId = await AuthenticationRepository().getUserId();
    if (likerUserId != null) {
      await _databaseRepository.likeUser(likerUserId, likedUserId);
      bool isMatch =
          await _databaseRepository.checkForMatch(likerUserId, likedUserId);
      if (isMatch) {
        ChatRepository().createMessageRoom(likedUserId);
        model.User? likedUser =
            await _databaseRepository.getUserById(likedUserId);
        model.User? currentUser =
            await _databaseRepository.getUserById(likerUserId);
        if (likedUser != null && currentUser != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MatchPage(currentUser: currentUser, likedUser: likedUser),
          ));
        }
      }
    }
  }

  Future<void> _dislikeUser(String dislikedUserId) async {
    String? dislikerUserId = await AuthenticationRepository().getUserId();
    if (dislikerUserId != null) {
      await _databaseRepository.dislikeUser(dislikerUserId, dislikedUserId);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Distance'),
                  Slider(
                    value: _distance,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: '${_distance.toInt()} km',
                    onChanged: (double value) {
                      setState(() {
                        _distance = value;
                      });
                    },
                  ),
                  const Text('Gender'),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const Text('Age'),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 60,
                    divisions: 42,
                    labels: RangeLabels(
                      _ageRange.start.round().toString(),
                      _ageRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _ageRange = values;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchUsers();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchUsers();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Explain why you would report this user'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Report',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchUsers();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchUsers();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _swipeLeft() {
    if (_users.isNotEmpty) {
      String dislikedUserId = _users.first.id!;
      _dislikeUser(dislikedUserId);
      setState(() {
        _users.removeAt(0);
      });
    }
  }

  void _swipeRight() async {
    if (_users.isNotEmpty) {
      String likedUserId = _users.first.id!;
      await _likeUser(likedUserId);
      setState(() {
        _users.removeAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '    Home',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.report_problem, color: Colors.black),
            onPressed: _showReportDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(), // Show loading indicator
              ),
            )
          : _users.isEmpty
              ? Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'No more users',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 24),
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    model.User currentUser = _users.first;
                    String? filePath = currentUser.filePath;
                    return Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileDetail(user: currentUser),
                                ));
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                      height: constraints.maxHeight * 0.035),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: filePath != null
                                              ? Image.network(
                                                  filePath,
                                                  fit: BoxFit.cover,
                                                  width: constraints.maxWidth,
                                                  height:
                                                      constraints.maxHeight *
                                                          0.60,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Container(
                                                        width: constraints
                                                            .maxWidth,
                                                        height: constraints
                                                                .maxHeight *
                                                            0.60,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              : Container(
                                                  width: constraints.maxWidth,
                                                  height:
                                                      constraints.maxHeight *
                                                          0.60,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.person,
                                                      size: constraints
                                                              .maxHeight *
                                                          0.3),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: constraints.maxWidth,
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.amber,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${currentUser.name} ',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Diet:  ${currentUser.diet}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical:
                                    20.0), // Increase the padding to move buttons higher
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: constraints.maxWidth *
                                      0.1, // Increase circle avatar size
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.white, size: 40),
                                    onPressed: _swipeLeft,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: constraints.maxWidth *
                                      0.12, // Increase circle avatar size
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite,
                                        color: Colors.white, size: 60),
                                    onPressed: () {
                                      String superLikedUserId =
                                          _users.first.id!;
                                      _superLikeUser(superLikedUserId);
                                    },
                                  ),
                                ),
                                CircleAvatar(
                                  radius: constraints.maxWidth *
                                      0.1, // Increase circle avatar size
                                  backgroundColor: Colors.green,
                                  child: IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Colors.white, size: 40),
                                    onPressed: _swipeRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
