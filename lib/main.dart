import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:mausoleum/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mausoleum/api/firebase-api.dart';
import 'package:mausoleum/pages/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
      home: WidgetTree(),
    );
  }
}
