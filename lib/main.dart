import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/api/firebase-api.dart';
import 'package:mausoleum/rowandcolumn.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:mausoleum/pages/homepage.dart';
import 'package:mausoleum/models/overview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mausoleum/sqlitedb/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo_models/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

//Все будет состоять из виджетов, неизменяемый объект,
//который описывает часть UI
//виджет это обычный класс в языке dart

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

//StatelessWidget - неизменяемый виджет, состоящий из одного класса
//StatefulWidget - изменяемый виджет, состоящий из 2 классов, 
//один собственно неизменяемый StatelessWidget, другой изменяемый
//UI State виджет

//Декларативный подход
//UI = f(state)
//state состояние
//f это build метода виджетов

//Виджиты - видимые и невидимые
//Видимые - текст, карты, иконки, кнопки
 
//невидимые - позволяют структурировать контент, строка, колонка,
//листы,гриды
//контейнеры видимые и невидимый виджет

 // WidgetsFlutterBinding.ensureInitialized();
  // DBProvider dbHandler = DBProvider();
  // // Создаем базу данных при первом запуске приложения
  // await dbHandler.database;
  // dbHandler.setKey(); // Вызываем метод setKey() для инициализации selectedKey
  // String selectedKey = "";
  // String selectedValue = "";

  // //Здесь вы можете выполнять запросы SQL для работы с данными, например:
  // late Map<String, String> mapdata = dbHandler.mapdata;

  // String myfunc(String selectedKey) {
  //   for (var key in mapdata.keys) {
  //     if (key == selectedKey) {
  //       return mapdata[key]!;
  //     }
  //   }
  //   return "";
  // }

  // for (int i = 0; i < dbHandler.keysList.length; i++) {
  //   String selectedKey = dbHandler.keysList[i];
  //   String selectedValue = myfunc(selectedKey);
  //   //String selectedValue = dbHandler.selectedValues[i];
  //   await dbHandler.insertPerson(selectedKey, selectedValue);
  // }

  // // Получаем все записи из базы данных
  // List<Person> historypersons = await dbHandler.getPersons();
  // for (var historyperson in historypersons) {
  //   print(
  //       'Name: ${historyperson.selectedKey}, Bio: ${historyperson.selectedValue}');
  // }