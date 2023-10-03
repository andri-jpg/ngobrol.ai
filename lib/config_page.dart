import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ngobrol.ai/dashboard.dart';
import 'config.dart';
import 'shared.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool isOkButtonDisabled = false;
  final TextEditingController memoryController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController aiController = TextEditingController();
  double pValue = 0.88;
  int kValue = 5;
  double tValue = 0.78;
  String _responseMessage = '';

  @override
  void initState() {
    super.initState();

    // Mengambil nilai dari SharedPreferences dan menginisialisasi state
    memoryController.text = AppSettings.memory;
    userController.text = AppSettings.user;
    aiController.text = AppSettings.ai;
    pValue = AppSettings.pValue;
    kValue = AppSettings.kValue;
    tValue = AppSettings.tValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfigurasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: memoryController,
              decoration: const InputDecoration(
                labelText: 'Memory',
                hintText: 'Isi dengan sesuatu yang akan di ingat oleh AI',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Nama Anda (Pengguna):'),
            TextField(
              controller: userController,
              onChanged: (newValue) {
                ChatConfig.userMessageLabel = newValue;
              },
            ),
            const SizedBox(height: 20),
            const Text('Nama AI:'),
            TextField(
              controller: aiController,
              onChanged: (aiValue) {
                ChatConfig.aiMessageLabel = aiValue;
              },
            ),
            const SizedBox(height: 20),
            const Text('Top_p:'),
            Slider(
              value: pValue,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  pValue = value;
                });
              },
            ),
            Text('Nilai p: ${pValue.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Top_k:'),
            Slider(
              value: kValue.toDouble(),
              min: 1,
              max: 15,
              onChanged: (value) {
                setState(() {
                  kValue = value.toInt();
                });
              },
            ),
            Text('Nilai k: $kValue'),
            const SizedBox(height: 20),
            const Text('Temperature:'),
            Slider(
              value: tValue,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  tValue = value;
                });
              },
            ),
            Text('Nilai t: ${tValue.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isOkButtonDisabled ? null : () async {
                final configData = {
                  'memory': memoryController.text,
                  'user': userController.text,
                  'ai': aiController.text,
                  'p': pValue.toString(),
                  'k': kValue.toString(),
                  't': tValue.toString(),
                };
                await _sendConfigData(configData);
              },
              child: const Text('Submit'),
            ),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }

  Future<void> _sendConfigData(Map<String, dynamic> configData) async {
    final url = Uri.parse('http://0.0.0.0:8089/update_config');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(configData),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        // Update nilai-nilai di SharedPreferences setelah berhasil mengirim data
        AppSettings.memory = memoryController.text;
        AppSettings.user = userController.text;
        AppSettings.ai = aiController.text;
        AppSettings.pValue = pValue;
        AppSettings.kValue = kValue;
        AppSettings.tValue = tValue;

        setState(() {
          _responseMessage = 'Berhasil mengirim data ke server.';
        });

        _showSuccessDialog();
      } else {
        setState(() {
          _responseMessage = 'Gagal mengirim data ke server.';
        });

        _showErrorDialog();
      }
    } catch (e) {
      // Handle error
      setState(() {
        _responseMessage = 'Terjadi kesalahan.';
      });

      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Berhasil mengirim data ke server.'),
          actions: [
            TextButton(
              onPressed: isOkButtonDisabled ? null : () async {
                setState(() {
                  isOkButtonDisabled = true;
                });
                await _restartChat();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gagal'),
          content: const Text('Gagal mengirim data ke server.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restartChat() async {
    final url = Uri.parse('http://0.0.0.0:8089/handleinput');
    final requestBody = {'input': 'restart'};
    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } catch (e) {
      // Handle error
    }
  }
}
