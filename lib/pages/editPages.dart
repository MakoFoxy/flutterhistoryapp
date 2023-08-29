// import 'package:flutter/material.dart';
// import 'package:todo_models/todo_model.dart';
// import 'package:todo_repo/todo_repo.dart';
// import 'package:todo_services/data_models/dbtodo.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class EditPage extends StatefulWidget {
//   final TodoModel modelDB;
//   const EditPage({Key? key, required this.modelDB}) : super(key: key);

//   @override
//   State<EditPage> createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   PlatformFile? teFilePhoto;

//   Future selectFile() async {
//     final FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'jpg', 'jpeg', 'png'],
//       initialDirectory: '/storage/emulated/0/Download',
//     );

//     final fileres = await FilePicker.platform.pickFiles();
//     if (fileres == null) return;

//     setState(() {
//       teFilePhoto = fileres.files.first;
//       print('New pickedFile: ${teFilePhoto?.name}');
//     });

//     print("result $result");
//     print("pickedFile $teFilePhoto");
//   }

//   Future uploadFile() async {
//     final fileupload = await File(teFilePhoto!.path!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController teTitle =
//         TextEditingController(text: widget.modelDB.title);
//     TextEditingController teDecsription =
//         TextEditingController(text: widget.modelDB.description);
//     PlatformFile? teFilePhoto = PlatformFile(
//         size: 0,
//         name: "",
//         path: widget.modelDB.filephotopath);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(children: [
//             Container(
//               margin: const EdgeInsets.only(
//                 top: 15,
//                 left: 15,
//                 right: 15,
//               ),
//               child: TextField(
//                 controller: teTitle,
//                 decoration: const InputDecoration(
//                   hintText: 'Тарихи тұлға немесе ғимарат',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(
//                 top: 15,
//                 left: 15,
//                 right: 15,
//               ),
//               child: TextField(
//                 controller: teDecsription,
//                 decoration: const InputDecoration(
//                   hintText: 'Сипаттама',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Column(
//               children: [
//                 if (teFilePhoto != null)
//                   Container(
//                     color: Colors.green[200],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 200,
//                           height: 200,
//                           color: Colors.green[200],
//                           child: KeyedSubtree(
//                             key: UniqueKey(),
//                             child: Image.file(
//                               File(teFilePhoto?.path ?? ''),
//                               key: ValueKey<String>(teFilePhoto!.path!),
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         // SizedBox(
//                         //     height:
//                         //         8), // Отступ между изображением и текстом
//                         Text(teFilePhoto!.path!),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(
//                   vertical: 10), // или любые другие отступы
//               child: ElevatedButton(
//                 onPressed: selectFile,
//                 child: Text('Фотофайлды таңдаңыз'),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(
//                   vertical: 10), // или любые другие отступы
//               child: ElevatedButton(
//                 onPressed: uploadFile,
//                 child: Text('Фотофайлды жүктеу'),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               height: 60,
//               decoration: const BoxDecoration(
//                 color: Colors.amber,
//                 borderRadius: BorderRadius.all(Radius.circular(30)),
//               ),
//               margin: const EdgeInsets.all(15),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   // DBtodo dbTodo = DBtodo(letId: 1);
//                   // await dbTodo
//                   //     .checkData(); // Получаем уникальное значение letId
//                   var todo = TodoModel(
//                     letId: widget.modelDB.letId,
//                     title: teTitle.text,
//                     description: teDecsription.text,
//                     filephotopath: teFilePhoto!.path!,
//                   );
//                   TodoRepository().updateDB(todo);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Тарихи тұлғаны жаңарту'),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
