import 'package:flutter/material.dart';
import 'package:simple_chat/services/database.dart';

class NewMessage extends StatefulWidget {
  String chatUid;

  NewMessage(this.chatUid);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  final _service = DatabaseService();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    _service.createMessage(widget.chatUid, _enteredMessage.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            cursorColor: Colors.white60,
            style: const TextStyle(color: Colors.white),
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              label: Text(
                'Send a message...',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          ),
        ),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(
            Icons.send,
          ),
          color: Colors.white70,
        )
      ],
    );
  }
}
