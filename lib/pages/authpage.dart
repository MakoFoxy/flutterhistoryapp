import 'package:flutter/material.dart';
import 'package:mausoleum/pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mausoleum/pages/homepage.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Firebase auth");
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _sighOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Ваш код для аутентификации с email и паролем
      // Если аутентификация успешна, переходим на главную страницу
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации, если необходимо
      print('Ошибка при аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            ElevatedButton(
              onPressed: () => signInWithEmailAndPassword(context),
              child: const Text('Login'),
            ),
            _sighOutButton(),
          ],
        ),
      ),
    );
  }
}
