import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatroomsPage extends StatefulWidget {
  final String username;
  const ChatroomsPage({super.key, required this.username});

  @override
  State<ChatroomsPage> createState() => _ChatroomsPageState();
}

class _ChatroomsPageState extends State<ChatroomsPage> {
  List<String> _chatrooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatrooms();
  }

  Future<void> fetchChatrooms() async {
    final url = Uri.parse('http://localhost:8081/getChatrooms?username=${widget.username}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _chatrooms = List<String>.from(data['chatrooms']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // 에러 처리
      debugPrint('Failed to load chatrooms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatrooms')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chatrooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatrooms[index]),
                  onTap: () {
                    // 채팅방으로 이동하는 로직 추가 필요
                  },
                );
              },
            ),
    );
  }
}