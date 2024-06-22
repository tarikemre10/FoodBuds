class ChatRoom {
  final String senderName;
  final List<String> userIds;

  const ChatRoom({
    required this.senderName,
    required this.userIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'senderName': senderName,
    };
  }
}
