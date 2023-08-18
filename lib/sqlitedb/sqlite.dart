// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:mausoleum/models/overview.dart';
// import 'package:synchronized/synchronized.dart';
// import 'package:http/http.dart' as http;

// final Overview mapOver = Overview();

// class DBProvider {
//   static final DBProvider db = DBProvider();
//   Database? _database;
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await initDB();
//     return _database!;
//   }

//   initDB() async {
//     Directory documentsDirectory = await getApplicationSupportDirectory();
//     print('db location :' + documentsDirectory.path);
//     String path = join(documentsDirectory.path, "my_database.db");
//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//       await db.execute("CREATE TABLE IF NOT EXISTS historyperson ("
//           "id INTEGER PRIMARY KEY,"
//           "historyname TEXT,"
//           "historybio TEXT"
//           ")");
//     });
//   }

//   late Map<String, String> mapdata = mapOver.mapdatas;
//   late List<String> keysList = mapdata.keys.toList();

//   late String selectedKey;

//   void setKey() {
//     for (int i = 0; i < keysList.length; i++) {
//       selectedKey = keysList[i];
//       myfunc(this.selectedKey);
//     }
//   }

//   late String selectedValue = "";
//   late List<String> selectedValues = [];

//   String myfunc(String selectedKey) {
//     for (var key in mapdata.keys) {
//       if (key == selectedKey) {
//         this.selectedValue = mapdata[key]!;
//         this.selectedValues.add(selectedValue);
//       }
//     }
//     return "";
//   }

//   // Здесь вы можете добавить методы для работы с данными в базе данных, например:
//   Future<int> insertPerson(String selectedKey, String selectedValue) async {
//     Database db = await database;
//     return await db.rawInsert(
//       'INSERT INTO historyperson(historyname, historybio) VALUES (?, ?)',
//       [selectedKey, selectedValue],
//     );
//   }

//   Future<List<Person>> getPersons() async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('historyperson');
//     return maps
//         .map((map) => Person(
//               id: map['id'],
//               selectedKey: map['historyname'],
//               selectedValue: map['historybio'],
//             ))
//         .toList();
//   }
// }

// class Person {
//   int? id;
//   String selectedKey;
//   String selectedValue;

//   Person({this.id, required this.selectedKey, required this.selectedValue});
// }



//class DatabaseHandler {
//   static final DatabaseHandler _instance = DatabaseHandler._internal();

//   factory DatabaseHandler() => _instance;

//   static Database? _database;

//   DatabaseHandler._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     // Получаем путь к базе данных на устройстве
//     String databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'my_database.db');

//     // Открываем или создаем базу данных
//     _database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: onCreate,
//     );

//     return _database!;
//   }

//   Future<void> onCreate(Database db, int version) async {
//     // Создаем таблицу
//     await db.execute('''
//       CREATE TABLE person (
//         id INTEGER PRIMARY KEY,
//         name TEXT,
//         age INTEGER
//       )
//     ''');
//   }

//   // Здесь вы можете добавить методы для работы с данными в базе данных, например:
//   Future<int> insertPerson(String name, int age) async {
//     Database db = await database;
//     return await db.rawInsert(
//       'INSERT INTO person(name, age) VALUES (?, ?)',
//       [name, age],
//     );
//   }

//   Future<List<Person>> getPersons() async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('person');
//     return maps
//         .map((map) => Person(
//               id: map['id'],
//               name: map['name'],
//               age: map['age'],
//             ))
//         .toList();
//   }

//   // ... и так далее для других методов, которые вам понадобятся.

//   // Здесь вы также можете добавить методы для обновления или удаления данных.

//   // Или вы можете использовать sqflite API для работы с данными.
// }
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:typed_data';
// import 'dart:io';

// class DatabaseHandler {
//   static final DatabaseHandler _instance = DatabaseHandler._internal();

//   factory DatabaseHandler() => _instance;

//   static Database? _database;

//   DatabaseHandler._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     // Получаем путь к базе данных на устройстве
//     String databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'my_database.db');

//     // Открываем базу данных
//     _database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: onCreate,
//     );

//     return _database!;
//   }

//   Future<void> onCreate(Database db, int version) async {
//     // Создаем таблицу
//     await db.execute('''
//       CREATE TABLE person (
//         id INTEGER PRIMARY KEY,
//         name TEXT,
//         age INTEGER
//       )
//     ''');
//   }

//   Future<void> copyDatabaseFromAssets() async {
//     // Проверяем, существует ли уже база данных на устройстве
//     var databasesPath = await getDatabasesPath();
//     var path = join(databasesPath, 'my_database.db');
//     var exists = await databaseExists(path);

//     if (!exists) {
//       // Если файл не существует, копируем его из assets
//       ByteData data = await rootBundle.load("assets/my_database.db");
//       List<int> bytes = data.buffer.asUint8List();
//       await File(path).writeAsBytes(bytes);
//     }
//   }

//   Future<void> initDatabase() async {
//     Database db = await database;
//     await onCreate(db, 1);
//   }

//   Future<int> insertPerson(String name, int age) async {
//     Database db = await database;
//     return await db.rawInsert(
//       'INSERT INTO person(name, age) VALUES (?, ?)',
//       [name, age],
//     );
//   }

//   Future<List<Person>> getPersons() async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('person');
//     return maps
//         .map((map) => Person(
//               id: map['id'],
//               name: map['name'],
//               age: map['age'],
//             ))
//         .toList();
//   }

//   Future<int> updatePerson(int id, String name, int age) async {
//     Database db = await database;
//     return await db.rawUpdate(
//       'UPDATE person SET name = ?, age = ? WHERE id = ?',
//       [name, age, id],
//     );
//   }

//   Future<int> deletePerson(int id) async {
//     Database db = await database;
//     return await db.rawDelete('DELETE FROM person WHERE id = ?', [id]);
//   }
// }

// class Person {
//   int? id;
//   String name;
//   int age;

//   Person({this.id, required this.name, required this.age});
// }

// void main() async {
//   var dbHelper = DatabaseHandler();

//   // Создаем новую запись в базе данных
//   await dbHelper.insertPerson('John Doe', 30);

//   // Получаем все записи из базы данных
//   List<Person> persons = await dbHelper.getPersons();
//   for (var person in persons) {
//     print('Name: ${person.name}, Age: ${person.age}');
//   }
// }
