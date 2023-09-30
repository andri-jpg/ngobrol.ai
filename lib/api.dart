import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> sendImageToServer(String imagePath) async {
  final url = Uri.parse('http://0.0.0.0:8089/handleimage');
  final request = http.MultipartRequest('POST', url);
  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imagePath,
    )
  );
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  return response;
}


Future<http.Response> sendMessageToServer(String userInput) async {
  final url = Uri.parse('http://0.0.0.0:8089/handleinput');
  final requestBody = {'input': userInput};

  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {'Content-Type': 'application/json'},
  );

  return response;
}
