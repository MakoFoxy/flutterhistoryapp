import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo_models/todo_model.dart';
import 'package:todo_repo/todo_repo.dart';
import 'package:todo_services/data_models/dbtodo.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateHistoryPost extends StatefulWidget {
  @override
  State<CreateHistoryPost> createState() => _CreateHistoryPostState();
}

class _CreateHistoryPostState extends State<CreateHistoryPost> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'jpg', 'jpeg', 'png'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      pickedFile = fileres.files.first;
    });

    print("result $result");
    print("pickedFile $pickedFile");
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.path!}';
    final fileupload = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(fileupload);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  TextEditingController teTitle = TextEditingController();

  TextEditingController teDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  controller: teTitle,
                  decoration: const InputDecoration(
                    hintText: 'Тарихи тұлға немесе ғимарат',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  controller: teDescription,
                  decoration: const InputDecoration(
                    hintText: 'Сиппатама',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  if (pickedFile != null)
                    Container(
                      color: Colors.green[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Image.file(
                              File(pickedFile!.path!),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // SizedBox(
                          //     height:
                          //         8), // Отступ между изображением и текстом
                          Text(pickedFile!.path!),
                        ],
                      ),
                    ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: selectFile,
                  child: Text('Фотофайлды таңдаңыз'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: uploadFile,
                  child: Text('Фотофайлды жүктеу'),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              buildProgress(),
              Container(
                width: double.infinity,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: () async {                                   
                    DBtodo dbTodo = DBtodo();
                    await dbTodo
                        .checkData(); // Получаем уникальное значение letId
                    var todo = TodoModel(
                      letId: dbTodo.letId,
                      title: teTitle.text,
                      description: teDescription.text,
                      filephotopath: pickedFile!.path!,
                    );
                    TodoRepository().addTodo(todo);
                    Navigator.pop(context);

                   CollectionReference collRef = FirebaseFirestore.instance.collection('data');

                    collRef.add({
                      'title': teTitle.text,
                      'description': teDescription.text,
                      'filephotopath': pickedFile!.path!,
                    });

                    teTitle.clear();
                    teDescription.clear();
                    pickedFile = null;
                  },
                  child: const Text('Тарихи тұлғаны сақтау'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;

            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.green,
                    color: Colors.green,
                  ),
                  Center(
                      child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.green),
                  ))
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );
}
