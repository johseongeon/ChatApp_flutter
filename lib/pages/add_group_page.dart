import 'package:flutter/material.dart';
import 'select_friends_page.dart';
import 'package:http/http.dart' as http;

class AddGroupPage extends StatefulWidget {
  final String username;

  const AddGroupPage({super.key, required this.username});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _roomIdController = TextEditingController(text: '');

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

  void _goToSelectFriends() {
    String roomId = _roomIdController.text.trim();
    if (roomId.isNotEmpty) {
      final url = Uri.parse('http://192.168.0.12:8082/createRoom?room_id=${_roomIdController.text}');
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purpleAccent, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
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
