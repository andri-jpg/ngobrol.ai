// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ngobrol.AI',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'oxygen',
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Ngobrol.AI adalah aplikasi chatbot offline berbasis model GPT-2 yang menggunakan bahasa Indonesia. Chatbot ini masih dalam tahap pengembangan',
              style: TextStyle(fontSize: 16.0,
              fontFamily: 'oxygen'),
            ),
          
            const SizedBox(height: 16.0),
            InkWell(
              child: const Text(
                'Author',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'oxygen',
                  color: Colors.blue,
                ),
              ),
              onTap: () async {
                const url = 'https://github.com/andri-jpg/'; 
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Tidak dapat membuka tautan $url';
                    }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
