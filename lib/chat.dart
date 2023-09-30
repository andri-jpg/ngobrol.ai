// ignore_for_file: use_build_context_synchronously

import 'package:ngobrol.ai/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _colorTween = ColorTween(
      begin: Colors.blue,
      end: Colors.red, 
    ).animate(_animationController);
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: true,
    );

    setState(() {
      _messages.insert(0, message);
      _startLoading();
    });

    await Future.delayed(const Duration(seconds: 1));

    _sendMessageToServer(text);
  }

  void _sendMessageToServer(String userInput) async {
    final url = Uri.parse('http://0.0.0.0:8089/handleinput');
    final requestBody = {'input': userInput};

 try {
    final response = await http
        .post(
          url,
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 20)); 

    _stopLoading();


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final botResponse = data['result'];

      setState(() {
        _messages.insert(0, ChatMessage(text: botResponse, isUserMessage: false));
      });
    } else {
      handleError();
    }
  } catch (e) {
    // Handle timeout error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Request Timeout"),
          content: const Text(
              "Pastikan anda sudah membuka termux, atau tekan tombol Tutorial instalasi di bawah jika anda baru pertama kali menjalankan aplikasi ini."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TutorialPage(),
                  ),
                  );
              },
              child: const Text("Tutorial"),
            ),
          ],
        );
        });
        }
      }

  void handleError() {
    ChatMessage errorMessage = const ChatMessage(
      text: 'Maaf, terjadi kesalahan.', isUserMessage: false,
    );

    setState(() {
      _messages.insert(0, errorMessage);
    });
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    _animationController.repeat(); 
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
    _animationController.reset(); 
  }

  Widget _buildTextComposer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(32.0),
      ),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ketik disini....',
                ),
                enabled: !_isLoading,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: _isLoading ? Colors.grey : Colors.blue),
            onPressed: _isLoading ? null : () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngobrol'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          _buildTextComposer(),
          _isLoading
              ? AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      valueColor: _colorTween,
                      backgroundColor: Colors.grey[300],
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatMessage({Key? key, required this.text, required this.isUserMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isUserMessage ? ChatConfig.userMessageLabel : ChatConfig.aiMessageLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'oxygen',
                    ),
                    ),

                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}