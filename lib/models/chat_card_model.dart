class ChatCardModel {
  final String chatUid;
  final String username;
  final String userImageUrl;
  String lastMessage;
  final DateTime createdAt;

  ChatCardModel({
    required this.chatUid,
    required this.username,
    required this.userImageUrl,
    required this.lastMessage,
    required this.createdAt,
  });
}
