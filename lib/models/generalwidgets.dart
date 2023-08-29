// import 'dart:ffi';
// import 'package:mausoleum/models/overview.dart';
// import 'package:flutter/material.dart';
// import 'package:mausoleum/pages/homepage.dart';
// import 'package:mausoleum/models/overview.dart';
// import 'package:mausoleum/objectpage.dart';
// import 'package:todo_repo/todo_repo.dart';
// import 'package:todo_services/data_models/dbtodo.dart';
// import 'package:todo_models/todo_model.dart';
// import 'package:todo_services/database.dart';
// import 'package:mausoleum/pages/editPages.dart';
// import 'package:styled_text/styled_text.dart';

// Overview dataInform = Overview();
// DataName myDataName = DataName();

// class InfButton extends StatefulWidget {
//   late Map<String, String> mapdata;

//   InfButton({Key? key, required this.mapdata}) : super(key: key);

//   @override
//   State<InfButton> createState() => _InfButtonState();
// }

// TextEditingController keyword = TextEditingController();

// class _InfButtonState extends State<InfButton> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: keyword.text.length > 0
//           ? TodoRepository().searchDB(keyword.text)
//           : TodoRepository().getAllTodo(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           // Обработка ошибок при загрузке данных.
//           return Text("Ошибка при загрузке данных");
//         } else {
//           // Данные успешно загружены, отображаем их.
//           List<TodoModel> data =
//               snapshot.data ?? []; // Убедитесь, что data не null.
//           // Ваш код для отображения данных TodoModel.
//           YourWidgetToShowData(todoList: data);
//         }
//         final todo = snapshot.data as List<TodoModel>;
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: todo.length,
//           itemBuilder: (context, index) {
//             return Container(
//               margin: const EdgeInsets.only(top: 15),
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (BuildContext context) => EditPage(
//                             modelDB: todo[index],
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(left: 20, right: 20),
//                       child: Card(
//                         child: ListTile(
//                           title: Text(
//                             todo[index].title,
//                             style: TextStyle(
//                               color: Colors.amber,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           trailing: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 TodoRepository()
//                                     .deleteElemById(todo[index].letId);
//                               });
//                             },
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.amber,
//                             ),
//                           ),
//                           subtitle: Text(
//                             todo[index].description,
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 18,
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class YourWidgetToShowData extends StatefulWidget {
//   final List<TodoModel> todoList;

//   YourWidgetToShowData({required this.todoList});

//   @override
//   State<YourWidgetToShowData> createState() => _YourWidgetToShowDataState();
// }

// class _YourWidgetToShowDataState extends State<YourWidgetToShowData> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.todoList.length,
//       itemBuilder: (context, index) {
//         TodoModel task = widget.todoList[index];
//         return ListTile(
//           title: Text(task.title),
//           subtitle: Text(task.description),
//           // Дополнительные виджеты или функциональность для задачи.
//           // Например, чекбокс для пометки задачи как выполненной и т.д.
//         );
//       },
//     );
//   }
// }
