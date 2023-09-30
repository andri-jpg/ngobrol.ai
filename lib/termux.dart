import 'package:ngobrol.ai/chat.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


  
class TermuxRun extends StatelessWidget {
  const TermuxRun({super.key});

  Future<void> _launchTermux() async {
    const url = 'https://play.google.com/store/apps/details?id=com.termux';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Tidak dapat membuka Termux';
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Termux'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tutorial ini hanya untuk kamu yang telah melakukan instalasi.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '\nLangkah 1: Buka Termux',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
                          ElevatedButton(
              onPressed: _launchTermux,
              child: const Text('Buka Termux'),
            ),

            const SizedBox(height: 20),
            const Text(
              'Langkah 2: Jalankan Script dibawah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Buka Termux dan paste kode di bawah ini:'),
            const SizedBox(height: 10),
            Container(
  padding: const EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(4.0),
  ),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Script untuk run Server Offline',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () async {
              const script = '''
python ngobrol.py
''';
              await Clipboard.setData(const ClipboardData(text: script));
            },
            child: const Text('Salin'),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const SelectableText(
        '''
python ngobrol.py
''',
        style: TextStyle(fontFamily: 'monospace'),
      ),
    ],
  ),
),

            const SizedBox(height: 20),
            Image.asset('images/run2.gif'),
            const Text(
              'Langkah 3: Keluar Dari termux dan Ngobrol.AI siap digunakan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()), // Ganti dengan laman yang sesuai
    );
  },
  child: const Text('Mulai chat'), ),

            const Text(
              'Setelah menggunakan Ngobrol.AI, kamu bisa mematikan server local dengan cara dibawah',
              style: TextStyle(fontSize: 16),
            ),
            Image.asset('images/close.gif'),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
