import 'dart:convert';
import 'package:chat_flutter/pages/add_friend_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chatrooms_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FriendsPage extends StatefulWidget {
  final String username;
  const FriendsPage({super.key, required this.username});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> _friends = [];
  bool _isLoading = true;
  int _selectedIndex = 1;
  String? serverUrl = dotenv.env['CHAT_SERVER_URL'];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    final url = Uri.parse('http://10.0.2.2:8082/getFriends?username=${widget.username}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _friends = List<String>.from(data['friends']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Failed to load friends');
    }
  }

  void _chatroomsPage(BuildContext context, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatroomsPage(username: username),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _chatroomsPage(context, widget.username);
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
        title: const Text('친구 목록'),
      actions: [
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFriendPage(username: widget.username),
          ),
        );
      },
      child: const Text('친구 추가', style: TextStyle(color: Colors.blue),
      ),
    ),
        ],
      ),
      
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_friends[index]),
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
