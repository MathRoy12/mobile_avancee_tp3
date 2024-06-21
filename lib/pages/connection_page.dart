import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_avancee_tp3/pages/home_page.dart';

import '../generated/l10n.dart';
import '../services/account_service.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool isLoading = false;

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> signin() async {
    await signInWithGoogle();
    if (FirebaseAuth.instance.currentUser != null) {
      navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).connection),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: MaterialButton(
            onPressed: signin,
            color: Colors.blue,
            child: Text(
              S.of(context).connection,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
