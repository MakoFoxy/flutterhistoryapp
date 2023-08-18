import 'package:flutter/material.dart';
import 'package:todo_models/todo_model.dart';
import 'package:todo_services/database.dart';
import 'package:todo_services/data_models/dbtodo.dart';

class TodoRepository {
  Future<void> addTodo(TodoModel todo) async {
    await DBProvider.db.addTodo(DBtodo(
      letId: todo.letId,
      title: todo.title,
      description: todo.description,
      filephotopath: todo.filephotopath
    ));
  }

  Future<List<TodoModel>> getAllTodo() async {
    final getinf = await DBProvider.db.getAllTodo();
    return getinf
        .map((e) => TodoModel(
            letId: e.letId, title: e.title, description: e.description, filephotopath: e.filephotopath))
        .toList();
  }

  Future<void> deleteElemById(int letId) async {
    await DBProvider.db.deleteElemById(letId);
  }

  Future updateDB(TodoModel mydb) async {
    final result = await DBProvider.db.updateElembyId(DBtodo(
      letId: mydb.letId,
      title: mydb.title,
      description: mydb.description,
      filephotopath: mydb.filephotopath,
    ));
    return result;
  }

  Future<void> deleteAlltables() async {
    await DBProvider.db.deleteAlltables();
  }

  Future<List<TodoModel>> searchDB(String keyword) async {
    final getinf = await DBProvider.db.searchDB(keyword);
    print(getinf);
    return getinf
        .map((e) => TodoModel(
              letId: e.letId,
              title: e.title,
              description: e.description,
              filephotopath: e.filephotopath,
            ))
        .toList();
  }
}







  // Future<List<DBtodo>> searchDB(String keyword) async {
  //   late List<int> searchId = [];
  //   late List<String> searchTitle = [];
  //   late List<String> searchDescription = [];
  //   late String searchKey;
  //   late int takeId;
  //   late String takeTitle;
  //   late String takeDescription;

  //   //final db = await database;
  //   //var res = await db.query("HistoryPerson");

  //   List<TodoModel> getData = await TodoRepository().getAllTodo();
  //   for (int i = 0; i < getData.length; i++) {
  //     TodoModel getInfo = getData[i];
  //     if (getInfo.letId != null &&
  //         getInfo.title != null &&
  //         getInfo.description != null) {
  //       searchId.add(getInfo.letId);
  //       searchTitle.add(getInfo.title);
  //       searchDescription.add(getInfo.description);
  //     }
  //   }

  //   searchKey = "";
  //   for (var i = 0; i < searchTitle.length; i++) {
  //     if (keyword == searchTitle[i]) {
  //       searchKey = searchKey + searchTitle[i];
  //     }
  //   }

  //   for (int i = 0; i < getData.length; i++) {
  //     TodoModel getInfo = getData[i];
  //     if (getInfo.title == searchKey) {
  //       takeTitle = getInfo.title;
  //       takeId = getInfo.letId;
  //       takeDescription = getInfo.description;
  //     }
  //   }
  //   List<DBtodo> result = [
  //     DBtodo(
  //       letId: takeId,
  //       title: takeTitle,
  //       description: takeDescription,
  //     )
  //   ];

  //   return Future.value(result);
  // }
