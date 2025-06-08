import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chatrooms_page.dart';

class SelectFriendsPage extends StatefulWidget {
  final String username;
  final String roomId;
  const SelectFriendsPage({super.key, required this.username, required this.roomId});

  @override
  State<SelectFriendsPage> createState() => _SelectFriendsPageState();
}

class _SelectFriendsPageState extends State<SelectFriendsPage> {
  List<String> friends = [];
  Set<String> selectedFriends = {};

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
        friends = List<String>.from(data['friends']);
      });
    } else {
      debugPrint('Failed to load friends');
    }
  }

  void toggleSelection(String friend) {
    setState(() {
      if (selectedFriends.contains(friend)) {
        selectedFriends.remove(friend);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  void onCompleteSelection() async {
  final roomId = widget.roomId;
  final futures = <Future>[];

  
  // 선택된 친구들을 roomId에 join
  for (var friend in selectedFriends) {
    final url = Uri.parse('http://10.0.2.2:8082/joinUser?username=$friend&room_id=$roomId');
    futures.add(http.get(url));
  }

  // 현재 사용자도 방에 join
  final currentUserUrl = Uri.parse('http://10.0.2.2:8082/joinUser?username=${widget.username}&room_id=$roomId');
  futures.add(http.get(currentUserUrl));

  // 모든 요청 대기
  await Future.wait(futures);

  // 완료 후 이전 페이지로 돌아가기
  if (mounted) {
    _chatroomsPage(context, widget.username);
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('select friends', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: onCompleteSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Text('선택 완료'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  final isSelected = selectedFriends.contains(friend);
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(friend, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: GestureDetector(
                      onTap: () => toggleSelection(friend),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.lightBlue, width: 2),
                          color: isSelected ? Colors.lightBlue : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
