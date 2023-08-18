import 'package:todo_repo/todo_repo.dart';
import 'package:todo_models/todo_model.dart';

class DBtodo {
  late int letId;
  Future<void> checkData() async {
    List<TodoModel> getData = await TodoRepository().getAllTodo();
    int maxId = 0;
    for (int i = 0; i < getData.length; i++) {
      TodoModel getId = getData[i];
      if (getId.letId != null && getId.letId > maxId) {
        maxId = getId.letId;
      }
    }
    letId = maxId + 1;
  }

  String title;
  String description;
  String filephotopath;
  double relevance; // Добавляем поле relevance

  DBtodo({
    this.letId = 0,
    this.title = '',
    this.description = '',
    this.filephotopath = '',
    this.relevance = 0.0, // Устанавливаем значение по умолчанию для relevance
  });

  factory DBtodo.fromMap(Map<String, dynamic> json) => DBtodo(
        letId: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        filephotopath: json['filephotopath'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': letId,
        'title': title,
        'description': description,
        'filephotopath': filephotopath,
      };

  @override
  String toString() {
    return 'DBtodo{letId: $letId, title: $title, description: $description, filephotopath: $filephotopath}';
  }
}
