import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xFF039BE5) : const Color(0xFFF2F3F5);
    final textColor = isMe ? Colors.white : Colors.black87;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
        Padding(
      padding: const EdgeInsets.only(top: 30), // 숫자 조절 가능
        child: CircleAvatar(
            radius: 16,
            child: Text(sender.isNotEmpty ? sender[0].toUpperCase() : '?'),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    sender,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                if (!isMe) const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isMe) const SizedBox(width: 8), // 아바타와 간격 확보
      ],
    );
  }
}
