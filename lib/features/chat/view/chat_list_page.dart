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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _chatsFuture = _repository.getChats();
    _searchFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

  Widget _buildSearchBar() {
    final bool isSearching = _searchFocusNode.hasFocus || _searchQuery.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSearching
                ? const Color(0xFFD41470)
                : Colors.grey.shade200,
            width: 1.0,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search by name or message...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: isSearching
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFD41470), size: 20),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _searchFocusNode.unfocus();
                      });
                    },
                  )
                : Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.cancel, color: Colors.grey.shade600, size: 18),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
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
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder<List<ChatModel>>(
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
                final filteredChats = _searchQuery.isEmpty
                    ? chats
                    : chats.where((chat) {
                        final query = _searchQuery.toLowerCase();
                        return chat.name.toLowerCase().contains(query) ||
                            chat.lastMessage.toLowerCase().contains(query);
                      }).toList();

                if (filteredChats.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No conversations yet'
                                : 'No chat found for "$_searchQuery"',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredChats.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
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
          ),
        ],
      ),
    );
  }
}
