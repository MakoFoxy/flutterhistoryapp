import 'package:todo_repo/todo_repo.dart';
import 'package:todo_models/todo_model.dart';

class TodoModel {
  late int letId;
  late String title;
  late String description;
  late String filephotopath;

  TodoModel({
    required this.letId,
    required this.title,
    required this.description,
    required this.filephotopath,
  });
}
