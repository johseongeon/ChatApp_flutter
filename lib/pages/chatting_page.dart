import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widgets/chat_bubble.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRoomPage extends StatefulWidget {
  final String username;
  final String roomId;

  const ChatRoomPage({super.key, required this.username, required this.roomId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  String? serverUrl = dotenv.env['CHAT_SERVER_URL'];

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
    _connectWebSocket();
  }

  Future<void> _fetchChatHistory() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/history?room_id=${widget.roomId}'));

    if (response.statusCode == 200) {
      final List<dynamic> history = jsonDecode(response.body);
      setState(() {
        messages.addAll(history
            .cast<Map<String, dynamic>>()
            .map((msg) => {
                  'from': msg['username'],
                  'message': msg['message'],
                  'timestamp': msg['timestamp'],
                }));
      });
    }
  }

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws');

    // send join info
    channel.sink.add(jsonEncode({
      'username': widget.username,
      'chat_id': widget.roomId,
    }));

    // listen for incoming messages
    channel.stream.listen((data) {
      final msg = jsonDecode(data);
      setState(() {
        messages.add({
          'from': msg['from'],
          'message': msg['message'],
          'timestamp': msg['timestamp'],
        });
      });
    });
  }


void _sendMessage() {
  if (_controller.text.trim().isEmpty) return;

  final message = _controller.text.trim();
  channel.sink.add(jsonEncode({'message': message}));

  setState(() {
    messages.add({
      'from': widget.username,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  });

  _controller.clear();
}

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomId)),
      body: Column(
        children: [
          Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final msg = messages[index];
      final from = msg['from'] ?? 'unknown';
      final content = msg['message'] ?? '';
      final isMe = from == widget.username;

      return ChatBubble(
        sender: from,
        message: content,
        isMe: isMe,
      );
    },
  ),
),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
