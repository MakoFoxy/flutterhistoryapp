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
  // late String description = "";
  // late String title = "";

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebase_en;

  TextEditingController xCoordinate = TextEditingController();
  TextEditingController yCoordinate = TextEditingController();
  final id = TextEditingController();
  final teTitleKz = TextEditingController();
  final teDecsriptionKz = TextEditingController();
  final teTitleRu = TextEditingController();
  final teDecsriptionRu = TextEditingController();
  final teTitleEn = TextEditingController();
  final teDecsriptionEn = TextEditingController();
  final teId = TextEditingController();

  late double xCoordinateNum;
  late double yCoordinateNum;

  position(xCoordinate, yCoordinate) {
    xCoordinateNum = double.parse(xCoordinate.text);
    yCoordinateNum = double.parse(yCoordinate.text);
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
                top: 10,
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: id,
                decoration: const InputDecoration(
                  hintText: 'id',
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
                controller: teTitleKz,
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
                controller: teTitleRu,
                decoration: const InputDecoration(
                  hintText: 'Историческая персона или объект',
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
                controller: teTitleEn,
                decoration: const InputDecoration(
                  hintText: 'Historical person or object',
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
                controller: teDecsriptionKz,
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
                top: 15,
                left: 15,
                right: 15,
              ),
              child: TextField(
                controller: teDecsriptionRu,
                decoration: const InputDecoration(
                  hintText: 'Описание',
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
                controller: teDecsriptionEn,
                decoration: const InputDecoration(
                  hintText: 'Description',
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
                  CollectionReference<Map<String, dynamic>> collRefKz;
                  CollectionReference<Map<String, dynamic>> collRefRu;
                  CollectionReference<Map<String, dynamic>> collRefEn;
                  collRefKz = FirebaseFirestore.instance.collection('datakz');
                  collRefRu = FirebaseFirestore.instance.collection('dataru');
                  collRefEn = FirebaseFirestore.instance.collection('dataen');

                  String targetTitle =
                      widget.selectedKey; // Значение, которое вы ищете

                  try {
                    QuerySnapshot querySnapshotKz = await collRefKz.get();
                    QuerySnapshot querySnapshotRu = await collRefRu.get();
                    QuerySnapshot querySnapshotEn = await collRefEn.get();

                    List<QueryDocumentSnapshot> docsKz = querySnapshotKz.docs;
                    List<QueryDocumentSnapshot> docsRu = querySnapshotRu.docs;
                    List<QueryDocumentSnapshot> docsEn = querySnapshotEn.docs;

                    for (QueryDocumentSnapshot docKz in docsKz) {
                      Map<String, dynamic> autodata =
                          docKz.data() as Map<String, dynamic>;
                      String autokeyKz = docKz.id; // Получение ключа документа

                      // Проверка, соответствует ли поле title значению, которое вы ищете
                      if (autokeyKz == autokeyKz) {
                        print("ElevButton teTitle $targetTitle");
                        print(
                            "ElevButton teDecsription ${teDecsriptionKz.text}");
                        print(
                            "ElevButton selectedKey for firebase ${widget.selectedKey}");

                        print('autokey $autokeyKz');
                        print('data $autodata');

                        await collRefKz.doc(autokeyKz).update({
                          'id': id.text,
                          'title': teTitleKz.text,
                          'description': teDecsriptionKz.text,
                          'filephotopath': teFilePhoto!.path!,
                          'xCoordinate': xCoordinateNum,
                          'yCoordinate': yCoordinateNum,
                        });
                        print("Document updated: $autokeyKz");
                        break; // Прерываем цикл после обновления первого соответствующего документа
                      }
                    }
                    for (QueryDocumentSnapshot docRu in docsRu) {
                      Map<String, dynamic> autodata =
                          docRu.data() as Map<String, dynamic>;
                      String autokeyRu = docRu.id; // Получение ключа документа

                      // Проверка, соответствует ли поле title значению, которое вы ищете
                      if (autokeyRu == autokeyRu) {
                        print("ElevButton teTitle $targetTitle");
                        print(
                            "ElevButton teDecsription ${teDecsriptionKz.text}");
                        print(
                            "ElevButton selectedKey for firebase ${widget.selectedKey}");

                        print('autokey $autokeyRu');
                        print('data $autodata');

                        await collRefRu.doc(autokeyRu).update({
                          'id': id.text,
                          'title': teTitleRu.text,
                          'description': teDecsriptionRu.text,
                          'filephotopath': teFilePhoto!.path!,
                          'xCoordinate': xCoordinateNum,
                          'yCoordinate': yCoordinateNum,
                        });
                        print("Document updated: $autokeyRu");
                        break; // Прерываем цикл после обновления первого соответствующего документа
                      }
                    }
                    for (QueryDocumentSnapshot docEn in docsEn) {
                      Map<String, dynamic> autodata =
                          docEn.data() as Map<String, dynamic>;
                      String autokeyEn = docEn.id; // Получение ключа документа

                      // Проверка, соответствует ли поле title значению, которое вы ищете
                      if (autokeyEn == autokeyEn) {
                        print("ElevButton teTitle $targetTitle");
                        print(
                            "ElevButton teDecsription ${teDecsriptionEn.text}");
                        print(
                            "ElevButton selectedKey for firebase ${widget.selectedKey}");

                        print('autokey $autokeyEn');
                        print('data $autodata');

                        await collRefEn.doc(autokeyEn).update({
                          'id': id.text,
                          'title': teTitleEn.text,
                          'description': teDecsriptionEn.text,
                          'filephotopath': teFilePhoto!.path!,
                          'xCoordinate': xCoordinateNum,
                          'yCoordinate': yCoordinateNum,
                        });
                        print("Document updated: $autokeyEn");
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



  // Future<void> fetchKeysFirebase() async {
  //   late QuerySnapshot<Map<String, dynamic>> datakz;
  //   late QuerySnapshot<Map<String, dynamic>> dataru;
  //   late QuerySnapshot<Map<String, dynamic>> dataen;

  //   if (Localizations.localeOf(context).languageCode == 'kk') {
  //     datakz = await FirebaseFirestore.instance.collection('datakz').get();
  //   } else if (Localizations.localeOf(context).languageCode == 'ru') {
  //     dataru = await FirebaseFirestore.instance.collection('dataru').get();
  //   } else if (Localizations.localeOf(context).languageCode == 'en') {
  //     dataen = await FirebaseFirestore.instance.collection('dataen').get();
  //   }

  //   datafirebasekz = datakz.docs.toList();
  //   datafirebaseru = dataru.docs.toList();
  //   datafirebase_en = dataen.docs.toList();

  //   for (int i = 0; i < datafirebasekz!.length; i++) {
  //     if (widget.selectedKey == datafirebasekz![i]['title']) {
  //       description = datafirebasekz![i]['description'];
  //       title = datafirebasekz![i]['title'];
  //       xCoordinate = datafirebasekz![i]['xCoordinate'];
  //       yCoordinate = datafirebasekz![i]['yCoordinate'];

  //       //idnum = datafirebase![i]['id'];
  //       teTitleKz.text = title; // Инициализация контроллера
  //       teDecsriptionKz.text = description; // Инициализация контроллера
  //       //teId.text = idnum;
  //       break;
  //     }
  //   }

  //   for (int i = 0; i < datafirebaseru!.length; i++) {
  //     if (widget.selectedKey == datafirebaseru![i]['title']) {
  //       description = datafirebaseru![i]['description'];
  //       title = datafirebaseru![i]['title'];
  //       xCoordinate = datafirebaseru![i]['xCoordinate'];
  //       yCoordinate = datafirebaseru![i]['yCoordinate'];

  //       //idnum = datafirebase![i]['id'];
  //       teTitleRu.text = title; // Инициализация контроллера
  //       teDecsriptionRu.text = description; // Инициализация контроллера
  //       //teId.text = idnum;
  //       break;
  //     }
  //   }

  //   for (int i = 0; i < datafirebase_en!.length; i++) {
  //     if (widget.selectedKey == datafirebase_en![i]['title']) {
  //       description = datafirebase_en![i]['description'];
  //       title = datafirebase_en![i]['title'];
  //       xCoordinate = datafirebase_en![i]['xCoordinate'];
  //       yCoordinate = datafirebase_en![i]['yCoordinate'];

  //       //idnum = datafirebase![i]['id'];
  //       teTitleEn.text = title; // Инициализация контроллера
  //       teDecsriptionEn.text = description; // Инициализация контроллера
  //       //teId.text = idnum;
  //       break;
  //     }
  //   }
  //   //id = int.parse(teId.text);
  //   print("teTitle ${teTitleKz.text}");
  //   print("teDecsription ${teDecsriptionKz.text}");
  //   print("teTitle ${teTitleRu.text}");
  //   print("teDecsription ${teDecsriptionRu.text}");
  //   print("teTitle ${teTitleEn.text}");
  //   print("teDecsription ${teDecsriptionEn.text}");
  //   print("selectedKey fo firebase ${widget.selectedKey}");
  // }
