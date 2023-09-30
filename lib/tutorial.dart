import 'package:ngobrol.ai/termux.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tutorial instalasi ini hanya dilakukan sekali. Jika kamu sudah berhasil melakukan instalasi.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TermuxRun()));
              },
              child: const Text(
                'klik disini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Text(
              '\nLangkah 1: Unduh dan Instal Termux',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Unduh aplikasi Termux dari F-Droid:'),
            InkWell(
              onTap: () async {
                const url = 'https://f-droid.org/repo/com.termux_118.apk'; 
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Tidak dapat membuka tautan $url';
                    }
              },
              child: const Text(
                'https://f-droid.org/repo/com.termux_118.apk',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Langkah 2: Install Ngobrol.AI Offline',
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
            'Script Instalasi:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () async {
              const script = '''
pkg update -y
pkg install -y build-essential binutils rust python python-pip wget git

wget https://huggingface.co/AndriLawrence/gpt2-chatkobi-ai/resolve/main/ngobrol.bin
wget https://huggingface.co/AndriLawrence/gpt2-chatkobi-ai/resolve/main/ngobrol.meta
wget https://raw.githubusercontent.com/andri-jpg/ngobrol.ai/main/termux/requirements.txt
wget https://raw.githubusercontent.com/andri-jpg/ngobrol.ai/main/termux/ngobrol.py

echo 'python ngobrol.py' > script.sh
chmod +x script.sh
pip install -r requirements.txt
echo "Installation completed successfully."
exit
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
pkg update -y
pkg install -y build-essential binutils rust python python-pip wget git

wget https://huggingface.co/AndriLawrence/gpt2-chatkobi-ai/resolve/main/ngobrol.bin
wget https://huggingface.co/AndriLawrence/gpt2-chatkobi-ai/resolve/main/ngobrol.meta
wget https://raw.githubusercontent.com/andri-jpg/ngobrol.ai/main/termux/requirements.txt
wget https://raw.githubusercontent.com/andri-jpg/ngobrol.ai/main/termux/ngobrol.py

echo 'python ngobrol.py' > script.sh
chmod +x script.sh
pip install -r requirements.txt
echo "Installation completed successfully."
exit
''',
        style: TextStyle(fontFamily: 'monospace'),
      ),
    ],
  ),
),

            const SizedBox(height: 20),
              const Text(
              '\nPaste script dan tekan enter, lalu tunggu sampai instalasi selesai.',
              style: TextStyle(fontSize: 16,),
            ),
            Image.asset('images/install.gif'),
            const Text(
              'Langkah 3: Jika instalasi berhasil, Termux otomatis keluar, kemudian buka termux kembali',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Instalasi selesai. untuk menggunakan Ngobrol.AI',
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TermuxRun()));
              },
              child: const Text(
                'klik disini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //Image.asset('images/run.gif'),
          ],
        ),
      ),
    );
  }
}
