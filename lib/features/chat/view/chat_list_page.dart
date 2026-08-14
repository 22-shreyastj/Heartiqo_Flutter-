import 'package:flutter/material.dart';

import '../model/chat_model.dart';
import '../repository/chat_repository.dart';
import '../widgets/online_indicator.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatRepository _repository = ChatRepository();
  late Future<List<ChatModel>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = _repository.getChats();
  }

  Widget _buildAvatar(ChatModel chat) {
    final image = chat.image;
    final name = chat.name;

    Widget avatarChild;
    if (image.startsWith('http://') || image.startsWith('https://')) {
      avatarChild = CircleAvatar(
        radius: 26,
        backgroundColor: const Color(0xFFFFDDEB),
        backgroundImage: NetworkImage(image),
        onBackgroundImageError: (exception, stackTrace) {},
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Color(0xFFD41470),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      avatarChild = CircleAvatar(
        radius: 26,
        backgroundColor: const Color(0xFFFFDDEB),
        child: ClipOval(
          child: Image.asset(
            image,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(0xFFD41470),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Stack(
      children: [
        avatarChild,
        Positioned(
          right: 0,
          bottom: 0,
          child: OnlineIndicator(isOnline: chat.isOnline, size: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<ChatModel>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD41470)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading chats',
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return const Center(
              child: Text('No conversations yet'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: _buildAvatar(chat),
                title: Text(
                  chat.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  chat.isTyping ? 'Typing...' : chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: chat.isTyping
                        ? const Color(0xFFD41470)
                        : Colors.grey.shade600,
                    fontStyle:
                        chat.isTyping ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.lastMessageTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (chat.unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD41470),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chat.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatId: chat.id,
                        name: chat.name,
                        image: chat.image,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
