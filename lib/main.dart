import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:mausoleum/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mausoleum/api/firebase-api.dart';
import 'package:mausoleum/pages/qrobjectpage.dart';
import 'package:mausoleum/pages/widget_tree.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  int firebaseInitializationCount = 0;
  if (Firebase.apps.isEmpty) {
    firebaseInitializationCount++;
    await Firebase.initializeApp();
    print('Firebase initialized $firebaseInitializationCount times');
  }
  await FirebaseApi().initNotifications();
  debugPaintSizeEnabled = false;
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('kk'),
        Locale('ru'),
        Locale('en'),
      ],
      path: 'lib/assets/translations',
      fallbackLocale: Locale('kk'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Turkestan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.openSansCondensedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}
