import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FriendsPage extends StatefulWidget {
  final String username;
  const FriendsPage({super.key, required this.username});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    final url = Uri.parse('http://localhost:8082/getFriends?username=${widget.username}');
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
      // 에러 처리
      debugPrint('Failed to load friends');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
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
    );
  }
}
