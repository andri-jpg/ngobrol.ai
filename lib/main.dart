// ignore_for_file: library_private_types_in_public_api

import 'package:ngobrol.ai/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:ngobrol.ai/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngobrol.AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 121, 237, 251)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
  }

  _checkTutorialStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShown') ?? false;

    if (tutorialShown) {
      _navigateToDashboard();
    } else {
      await _showTutorial();
      prefs.setBool('tutorialShown', true);
    }
  }

  Future<void> _showTutorial() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selamat Datang di ngobrol.AI'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Ikuti instruksi di bawah untuk menggunakan aplikasi ini tanpa koneksi internet.'),
                InkWell(
                  child: const Text(
                    'Klik disini.',
                    style: TextStyle(
                      color: Colors.blue, 
                      decoration: TextDecoration.underline, 
                    ),
                  ),
                  onTap: () async {
               Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TutorialPage(),
                  ),
                  );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToDashboard();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/splashh.jpg'),
      ),
    );
  }
}