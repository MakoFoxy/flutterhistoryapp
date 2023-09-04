import 'package:flutter/material.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditFirebasePage extends StatefulWidget {
  // QueryDocumentSnapshot<Map<String, dynamic>>? editMydb;
  // EditFirebasePage({Key? key, required this.editMydb}) : super(key: key);
  final String selectedKey;
  EditFirebasePage({
    required this.selectedKey,
  });
  @override
  State<EditFirebasePage> createState() => EditFirebasePageState();
}

class EditFirebasePageState extends State<EditFirebasePage> {
  PlatformFile? teFilePhoto;
  UploadTask? uploadTask;
  late String image_url;
  late String description = "";
  late String title = "";

  //late String idnum = "";
  //late int id=0;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebase;
  TextEditingController xCoordinate = TextEditingController();
  TextEditingController yCoordinate = TextEditingController();

  final teTitle = TextEditingController();
  final teDecsription = TextEditingController();
  final teId = TextEditingController();

  late double xCoordinateNum;
  late double yCoordinateNum;

  position(xCoordinate, yCoordinate) {
    xCoordinateNum = double.parse(xCoordinate.text);
    yCoordinateNum = double.parse(yCoordinate.text);
  }



  Future<void> fetchKeysFirebase() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('data').get();
    datafirebase = snapshot.docs.toList();

    for (int i = 0; i < datafirebase!.length; i++) {
      if (widget.selectedKey == datafirebase![i]['title']) {
        description = datafirebase![i]['description'];
        title = datafirebase![i]['title'];
        xCoordinate = datafirebase![i]['xCoordinate'];
        yCoordinate = datafirebase![i]['yCoordinate'];

        //idnum = datafirebase![i]['id'];
        teTitle.text = title; // Инициализация контроллера
        teDecsription.text = description; // Инициализация контроллера
        //teId.text = idnum;
        break;
      }
    }
    //id = int.parse(teId.text);
    print("teTitle ${teTitle.text}");
    print("teDecsription ${teDecsription.text}");
    print("selectedKey fo firebase ${widget.selectedKey}");
  }

  Future selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'jpg', 'jpeg', 'png'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      teFilePhoto = fileres.files.first;
      print('New pickedFile: ${teFilePhoto?.name}');
    });

    print("result $result");
    print("pickedFile $teFilePhoto");
  }

  Future uploadFile() async {
    final path = 'files/${teFilePhoto!.path!}';
    final fileupload = File(teFilePhoto!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(fileupload);
    });
    print('Download uploadTask $uploadTask');
    final snapshot = await uploadTask!.whenComplete(() {});
    print('Download snapshot $snapshot');

    final urlDownload = await snapshot.ref.getDownloadURL();
    image_url = urlDownload;
    print('Download Link $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(
                top: 15,
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
                top: 15,
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: teDecsription,
                decoration: const InputDecoration(
                  hintText: 'Сипаттама',
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
                controller: xCoordinate,
                decoration: const InputDecoration(
                  hintText: 'xCoordinate',
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
                controller: yCoordinate,
                decoration: const InputDecoration(
                  hintText: 'yCoordinate',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                if (teFilePhoto != null)
                  Container(
                    color: Colors.green[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          color: Colors.green[200],
                          child: KeyedSubtree(
                            child: Image.file(
                              File(teFilePhoto?.path! ?? ''),
                              key: ValueKey<String>(teFilePhoto!.path!),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //     height:
                        //         8), // Отступ между изображением и текстом
                        Text(teFilePhoto!.path!),
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
                  position(xCoordinate, yCoordinate);
                  var collRef = FirebaseFirestore.instance.collection('data');
                  String targetTitle =
                      widget.selectedKey; // Значение, которое вы ищете

                  try {
                    QuerySnapshot querySnapshot = await collRef.get();
                    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                    for (QueryDocumentSnapshot doc in docs) {
                      Map<String, dynamic> autodata =
                          doc.data() as Map<String, dynamic>;
                      String autokey = doc.id; // Получение ключа документа

                      // Проверка, соответствует ли поле title значению, которое вы ищете
                      if (autodata['title'] == targetTitle) {
                        print("ElevButton teTitle $targetTitle");
                        print("ElevButton teDecsription ${teDecsription.text}");
                        print(
                            "ElevButton selectedKey for firebase ${widget.selectedKey}");

                        print('autokey $autokey');
                        print('data $autodata');

                        await collRef.doc(autokey).update({
                          'title': teTitle.text,
                          'description': teDecsription.text,
                          'filephotopath': teFilePhoto!.path!,
                          'xCoordinate': xCoordinateNum,
                          'yCoordinate': yCoordinateNum,
                        });
                        print("Document updated: $autokey");
                        break; // Прерываем цикл после обновления первого соответствующего документа
                      }
                    }
                  } catch (e) {
                    print("Error updating document: $e");
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: const Text('Тарихи тұлғаны жаңарту'),
                key: ValueKey(
                    widget.selectedKey), // Используйте ValueKey с selectedKey
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
