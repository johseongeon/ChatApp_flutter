import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chatting_page.dart';
import 'add_group_page.dart';
import 'friends_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatroomsPage extends StatefulWidget {
  final String username;
  const ChatroomsPage({super.key, required this.username});

  @override
  State<ChatroomsPage> createState() => _ChatroomsPageState();
}

class _ChatroomsPageState extends State<ChatroomsPage> {
  List<String> _chatrooms = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
  String? serverUrl = dotenv.env['CHAT_SERVER_URL'];

  @override
  void initState() {
    super.initState();
    fetchChatrooms();
  }

  void _chatroomPage(BuildContext context, String username, String roomid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatRoomPage(username: username, roomId: roomid),
    ),
  );
}

  Future<void> fetchChatrooms() async {
    final url = Uri.parse('$serverUrl:8082/getRooms?username=${widget.username}');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _chatrooms = List<String>.from(data['rooms']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _friendsPage(BuildContext context, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendsPage(username: username),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _friendsPage(context, widget.username);
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings tapped (not implemented)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('채팅방 목록'),
        actions: [
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddGroupPage(username: widget.username),
          ),
        );
      },
      child: const Text('+', style: TextStyle(color: Colors.blue, fontSize: 30),
      ),
    ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chatrooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatrooms[index]),
                  onTap: () {
                    _chatroomPage(context, widget.username, _chatrooms[index]);
                  },
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}