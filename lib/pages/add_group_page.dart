import 'package:flutter/material.dart';
import 'select_friends_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddGroupPage extends StatefulWidget {
  final String username;

  const AddGroupPage({super.key, required this.username});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _roomIdController = TextEditingController(text: '');
  String? serverUrl = dotenv.env['CHAT_SERVER_URL'];

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

  void _goToSelectFriends() {
    String roomId = _roomIdController.text.trim();
    if (roomId.isNotEmpty) {
      final url = Uri.parse('http://10.0.2.2:8082/createRoom?room_id=${_roomIdController.text}');
      http.post(url, body: {
      'room_id': roomId,
    });


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SelectFriendsPage(username: widget.username, roomId: roomId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _roomIdController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(labelText: '채팅방 이름 입력'
                        ),
                      ),
                    ),
                    const Icon(Icons.edit, size: 16),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _goToSelectFriends,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '멤버 추가하기',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    );
  }
}
