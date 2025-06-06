import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'friends_page.dart';

class AddFriendPage extends StatefulWidget {
  final String username;
  const AddFriendPage({super.key, required this.username});

  @override
  State<AddFriendPage> createState() => _AddFriendPage();
}

class _AddFriendPage extends State<AddFriendPage> {
  final TextEditingController _usernameController = TextEditingController();
  String _responseMessage = '';

  Future<void> addFriend(String username, String friend) async {
    final url = Uri.parse('http://192.168.0.12:8082/addFriend?username=$username&friend=$friend');
    try {
      final response = await http.get(url);
      setState(() {
        if (response.statusCode == 200) {
          _responseMessage = '친구 추가 성공!';
        } else {
          _responseMessage = '추가 실패: ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        _responseMessage = '오류 발생: $e';
      });
    }
  }

  void _gotoFriendsPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FriendsPage(username: widget.username),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('친구 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: '친구 이름 입력'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final friend = _usernameController.text.trim();
                if (friend.isNotEmpty) {
                  addFriend(widget.username, friend);
                }
                _gotoFriendsPage();
              },
              child: const Text('친구 추가'),
            ),
            const SizedBox(height: 16),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
