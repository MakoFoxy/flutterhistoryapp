import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_services/data_models/dbtodo.dart';
import 'package:todo_repo/todo_repo.dart';
import 'package:todo_models/todo_model.dart';

class DBProvider {
  static final DBProvider db = DBProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  // initDB() async {
  //   Directory documentsDirectory = await getApplicationSupportDirectory();
  //   String path = join(documentsDirectory.path, "mydatabase.db");
  //   return await openDatabase(path, version: 1, onOpen: (db) {},
  //       onCreate: (Database db, int version) async {
  //     await db.execute("CREATE TABLE IF NOT EXISTS HistoryPerson ("
  //         "id INTEGER PRIMARY KEY,"
  //         "title TEXT,"
  //         "description TEXT"
  //         ")");
  //   });
  // }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "mydatabase.db");
    print("Путь к базе данных: $path");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE VIRTUAL TABLE IF NOT EXISTS HistoryPerson USING fts4 ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "rank INTEGER DEFAULT 0,"
          "filephotopath TEXT"
          // Добавьте столбец "rank" с типом INTEGER
          ")");
      await db.execute(
          "CREATE VIRTUAL TABLE IF NOT EXISTS HistoryPersonAux USING fts4aux(HistoryPerson);");
    });
  }

  addTodo(DBtodo todo) async {
    final db = await database;
   // String path = "/storage/emulated/0/flutter_application_2/images/";
    var row = await db.rawInsert(
      "INSERT Into HistoryPerson (id, title, description, filephotopath)"
      "VALUES (?,?,?,?)",
      [todo.letId, todo.title, todo.description, todo.filephotopath],
    );
    return row;
  }

  Future<List<DBtodo>> getAllTodo() async {
    final db = await database;
    var res = await db.query("HistoryPerson");
    List<DBtodo> list =
        res.isNotEmpty ? res.map((e) => DBtodo.fromMap(e)).toList() : [];
    return list;
  }

  deleteElemById(int letId) async {
    final db = await database;
    return db.delete("HistoryPerson", where: "id = ?", whereArgs: [letId]);
  }

  updateElembyId(DBtodo mydb) async {
    final db = await database;
    var res = await db.update(
      "HistoryPerson",
      mydb.toMap(),
      where: "id=?",
      whereArgs: [mydb.letId],
    );
    return res;
  }

  deleteAlltables() async {
    final db = await database;
    return db.rawDelete("Delete FROM HistoryPerson");
  }

  // Future<List<DBtodo>> searchDB(String keyword) async {
  //   final db = await database;
  //   String query = '''
  //   SELECT id, title, description, matchinfo(HistoryPerson) as info
  //   FROM HistoryPerson
  //   WHERE HistoryPerson MATCH '$keyword'
  //   ORDER BY rank;
  // ''';
  //   // String query = '''
  //   //   SELECT id, title, description, matchinfo(HistoryPerson) as info
  //   //   FROM HistoryPerson
  //   //   WHERE HistoryPerson MATCH "{title description} :$keyword" AND rank MATCH
  //   //   bm25(1.0, 1.0, 10.0) ORDER BY rank;
  //   // ''';

  //   List<Map<String, dynamic>> result = await db.rawQuery(query);

  //   List<DBtodo> searchResults = [];
  //   for (var row in result) {
  //     searchResults.add(DBtodo(
  //       letId: row['id'],
  //       title: row['title'],
  //       description: row['description'],
  //     ));
  //   }

  //   return searchResults;
  // }

//   Future<List<DBtodo>> searchDB(String keyword) async {
//     try {
//       final db = await database;
//       //   String query = '''
//       //   SELECT id, highlight(HistoryPerson, 1, "<bold>", "</bold>") title, highlight(HistoryPerson, 2, "<b>", "</b>") description, matchinfo(HistoryPerson) as info
//       //   FROM HistoryPerson
//       //   WHERE HistoryPerson MATCH '$keyword';
//       // ''';
//       String query = '''
//         SELECT id, title, description, matchinfo(HistoryPerson) as info
//         FROM HistoryPerson
//         WHERE HistoryPerson MATCH '$keyword';
//       ''';

//       List<Map<String, dynamic>> result = await db.rawQuery(query);

//       List<DBtodo> searchResults = [];
//       for (var row in result) {
//         List<int> matchInfo = row['info'];
//         double relevance = calculateRelevance(matchInfo);

//         // Создаем объект DBtodo с релевантностью
//         DBtodo todo = DBtodo(
//           letId: row['id'],
//           title: row['title'],
//           description: row['description'],
//         );

//         // Добавляем релевантность (relevance) как поле в объект DBtodo
//         todo.relevance = relevance;

//         searchResults.add(todo);
//       }

//       // Сортируем результаты по убыванию релевантности
//       searchResults.sort((a, b) => b.relevance.compareTo(a.relevance));

//       return searchResults;
//     } catch (error) {
//       print("Ошибка при выполнении запроса: $error");
//       throw error; // Добавьте эту строку для проброса ошибки
//     }
//   }

// // Вспомогательная функция для рассчета релевантности
//   double calculateRelevance(List<int> matchInfo) {
//     // Ваш код для расчета релевантности на основе данных 'matchinfo'
//     // Здесь вы можете использовать различные параметры из 'matchInfo', чтобы определить релевантность
//     // Чем больше совпадений и чем они более близки друг к другу, тем выше релевантность
//     // Это простой пример, вы можете настроить алгоритм под свои нужды

//     int totalMatches = matchInfo.fold(0, (sum, element) => sum + element);
//     double maxRelevance = 100.0; // Максимальное значение релевантности
//     double relevance = totalMatches * (maxRelevance / matchInfo.length);

//     return relevance;
//   }

  Future<List<DBtodo>> searchDB(String keyword) async {
    List<TodoModel> getData = await TodoRepository().getAllTodo();
    List<DBtodo> searchResults = [];

    for (int i = 0; i < getData.length; i++) {
      TodoModel getInfo = getData[i];
      int searchId = 0;
      String searchTitle = '';
      String searchDescription = '';
      String searchFilephotopath = '';

      if (getInfo.letId != null &&
          getInfo.title != null &&
          getInfo.description != null &&
          getInfo.filephotopath != null) {
        searchId = searchId + getInfo.letId;
        searchTitle = searchTitle + getInfo.title;
        searchDescription = searchDescription + getInfo.description;
        searchFilephotopath = searchFilephotopath + getInfo.filephotopath;
      }
      searchResults.add(DBtodo(
        letId: searchId,
        title: searchTitle,
        description: searchDescription,
        filephotopath: searchFilephotopath,
      ));
    }

    List<DBtodo> result = [];
    for (var i = 0; i < searchResults.length; i++) {
      // Выполняем полнотекстовый поиск в каждом элементе из списка searchResults
      if (searchResults[i].title.contains(keyword) ||
          searchResults[i].description.contains(keyword)) {
        result.add(DBtodo(
          letId: searchResults[i].letId,
          title: searchResults[i].title,
          description: searchResults[i].description,
          filephotopath: searchResults[i].filephotopath,
        ));
      }
    }

    result.sort((a, b) {
      int slengthA = a.title.length + a.description.length;
      int slengthB = b.title.length + b.description.length;
      return slengthB.compareTo(slengthA);
    });

    print("resaltum $result");
    return result;
  }
}

























// Future<List<DBtodo>> searchDB(String keyword) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> result = await db
  //       .rawQuery("SELECT * FROM HistoryPerson WHERE title=?", [keyword]);
  //   List<DBtodo> search =
  //       result.map((search) => DBtodo.fromMap(search)).toList();
  //   return search;
  // }

  // Future<List<DBtodo>> searchDB(String keyword) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> result = await db.rawQuery(
  //       'SELECT * FROM HistoryPerson WHERE title MATCH "$keyword" ORDER BY rank');
  //   List<DBtodo> search =
  //       result.map((search) => DBtodo.fromMap(search)).toList();
  //   return search;
  // }


