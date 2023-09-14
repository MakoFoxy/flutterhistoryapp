import 'package:mausoleum/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/authpage.dart';
import 'package:mausoleum/pages/login_registerpage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AuthPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
