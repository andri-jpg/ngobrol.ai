import 'dart:ui';
import 'package:ngobrol.ai/config_page.dart';
import 'package:ngobrol.ai/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:ngobrol.ai/about.dart';
import 'package:ngobrol.ai/chat.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/alice.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const BlurAppBar(), 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 220.0),
              _buildMenuItem(context, 'Ngobrol', Icons.chat, const ChatScreen()),
              _buildMenuItem(context, 'About', Icons.info, const About()),
              _buildMenuItem(context, 'Config', Icons.bolt, const ConfigPage()),
              _buildMenuItem(context, 'Tutorial', Icons.settings, const TutorialPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String label, IconData icon, Widget route) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => route),
              );
            },
            icon: Icon(icon),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.transparent,
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlurAppBar extends StatelessWidget {
  const BlurAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 80,
          color: Colors.black.withOpacity(0.29),
          child: const Center(
            child: Text(
              'Ngobrol.AI',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'oxygen'
              ),
            ),
          ),
        ),
      ),
    );
  }
}
