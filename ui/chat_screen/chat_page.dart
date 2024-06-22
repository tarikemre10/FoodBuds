import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/chat_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/models/models.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<List<ChatRoom>>? chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }


  void _loadChatRooms() {
    chatRoomsStream = ChatRepository().getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '    Chat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<List<ChatRoom>>(
          stream: chatRoomsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chat rooms available'));
            }
        
            List<ChatRoom> chatRooms = snapshot.data!;
            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return FutureBuilder<User>(
                  future: _getUserFromChatRoom(chatRooms[index]),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (userSnapshot.hasError) {
                      return Center(child: Text('Error: ${userSnapshot.error}'));
                    }
                    if (!userSnapshot.hasData) {
                      return Center(child: Text('User data not found'));
                    }
        
                    User user = userSnapshot.data!;
                    return ChatTile(user: user);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<User> _getUserFromChatRoom(ChatRoom chatRoom) async {
    String currentUserId =
        await AuthenticationRepository().getUserId() as String;
    String otherUserId =
        chatRoom.userIds.firstWhere((id) => id != currentUserId);
    return await DatabaseRepository().getUserById(otherUserId) as User;
  }
}

class ChatTile extends StatelessWidget {
  final User user;

  const ChatTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.filePath as String),
        ),
        title: Text(
          user.name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: const Text(
          "message",
          style: TextStyle(color: Color.fromARGB(255, 53, 53, 53)),
        ),
        trailing: const Text("time",
            style: TextStyle(color: Color.fromARGB(255, 31, 31, 31)),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                name: user.name,
                imageUrl: user.filePath as String,
                receiverId: user.id as String,
              ),
            ),
          );
        },
      ),
    );
  }
}
