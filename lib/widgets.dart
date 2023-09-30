import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildTextComposer(
    TextEditingController textController,
    bool isLoading,
    void Function(String) handleSubmitted,
    Function getImage,
    PickedFile? image) {
  final isImageReady = image != null; 

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
              controller: textController,
              onSubmitted: (text) => handleSubmitted(text),
              decoration: InputDecoration.collapsed(
                hintText: isImageReady ? 'Kirim gambar >>>' : 'Ketikkan pertanyaan Anda...',
              ),
              enabled: !isLoading, 
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.attach_file, color: isLoading ? Colors.grey : Colors.blue),
          onPressed: isLoading ? null : () => getImage(ImageSource.gallery),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt, color: isLoading ? Colors.grey : Colors.blue),
          onPressed: isLoading ? null : () => getImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(Icons.send, color: isLoading || isImageReady ? Colors.grey : Colors.blue),
          onPressed: isLoading || (!isImageReady && textController.text.isEmpty) ? null : () => handleSubmitted(textController.text),
        ),
      ],
    ),
  );
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final bool isImageUploading; 

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUserMessage,
    this.isImageUploading = false,
  }) : super(key: key);

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
                  isUserMessage ? 'Anda' : 'AI',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'oxygen',
                  ),
                ),
                if (isImageUploading)
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
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
