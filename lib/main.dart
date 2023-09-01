import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:mausoleum/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mausoleum/api/firebase-api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBR16jczb6AnZZoBdTh6Jlklm15zGDCKWU',
    appId: '1:734178320042:android:1f12e3d764300d9b8f7ad3',
    messagingSenderId: '734178320042',
    projectId: 'mausoleumfirebase',
    storageBucket: 'mausoleumfirebase.appspot.com/',
  ));
  await FirebaseApi().initNotifications();
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turkestan',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.openSansCondensedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}
