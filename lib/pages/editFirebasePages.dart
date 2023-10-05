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
  String myImageUrl = "";

  PlatformFile? pickedAudioFile;
  UploadTask? uploadAudioTask;
  String myAudioUrl = "";
  String pathAudio = "";
  // late String description = "";
  // late String title = "";

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebase_en;

  TextEditingController xCoordinateController = TextEditingController();
  TextEditingController yCoordinateController = TextEditingController();
  TextEditingController id = TextEditingController();

  TextEditingController teTitleKz = TextEditingController();
  TextEditingController teDecsriptionKz = TextEditingController();
  TextEditingController teTitleRu = TextEditingController();
  TextEditingController teDecsriptionRu = TextEditingController();
  TextEditingController teTitleEn = TextEditingController();
  TextEditingController teDecsriptionEn = TextEditingController();

  updateFirebase(String selectedKey) async {
    final datakz = await FirebaseFirestore.instance.collection('datakz').get();
    final dataru = await FirebaseFirestore.instance.collection('dataru').get();
    final dataen = await FirebaseFirestore.instance.collection('dataen').get();

    for (final doc in datakz.docs) {
      if (doc['id'] == selectedKey) {
        await doc.reference.update({
          'id': id.text,
          'title': teTitleKz.text,
          'description': teDecsriptionKz.text,
          'filephotopath': myImageUrl,
          'fileaudiopath': myAudioUrl,
          'firebaseaudiopath': pathAudio,
          'xCoordinate': double.parse(xCoordinateController.text),
          'yCoordinate': double.parse(yCoordinateController.text),
        });
        break;
      }
    }

    for (final doc in dataru.docs) {
      if (doc['id'] == selectedKey) {
        await doc.reference.update({
          'id': id.text,
          'title': teTitleRu.text,
          'description': teDecsriptionRu.text,
          'filephotopath': myImageUrl,
          'fileaudiopath': myAudioUrl,
          'firebaseaudiopath': pathAudio,
          'xCoordinate': double.parse(xCoordinateController.text),
          'yCoordinate': double.parse(yCoordinateController.text),
        });
        break;
      }
    }

    for (final doc in dataen.docs) {
      if (doc['id'] == selectedKey) {
        await doc.reference.update({
          'id': id.text,
          'title': teTitleEn.text,
          'description': teDecsriptionEn.text,
          'filephotopath': myImageUrl,
          'fileaudiopath': myAudioUrl,
          'firebaseaudiopath': pathAudio,
          'xCoordinate': double.parse(xCoordinateController.text),
          'yCoordinate': double.parse(yCoordinateController.text),
        });
        break;
      }
    }
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
      print('New teFilePhoto: ${teFilePhoto?.name}');
    });

    print("result $result");
    print("teFilePhoto $teFilePhoto");
  }

  Future uploadFile() async {
    final path = 'files/${teFilePhoto!.path!}';
    final fileupload = File(teFilePhoto!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(fileupload);
    });
    // final snapshot = await uploadTask!.whenComplete(() {});
    // print('Download snapshot $snapshot');
    try {
      final urlDownload = await ref.getDownloadURL();
      myImageUrl = urlDownload;
      print('Download Link $urlDownload');
    } catch (error) {
      print('Error uploading file: $error');
    }
    setState(() {
      uploadTask = null;
    });
  }

  Future selectAudioFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      pickedAudioFile = fileres.files.first;
    });

    print("result $result");
    print("pickedAudioFile $pickedAudioFile");
  }

  Future uploadAudioFile() async {
    pathAudio = 'files/${pickedAudioFile!.path!}';
    final fileupload = File(pickedAudioFile!.path!);

    final dataref = FirebaseStorage.instance.ref().child(pathAudio);
    setState(() {
      uploadAudioTask = dataref.putFile(fileupload);
    });
    print('Upload uploadTask $uploadAudioTask');
    try {
      // final snapshot = await uploadAudioTask!.whenComplete(() {});
      // print('Upload snapshot $snapshot');
      final urlAudioDownload = await dataref.getDownloadURL();
      myAudioUrl = urlAudioDownload;
      print('Download Link $urlAudioDownload');

      // // Передача filePath при создании MusicPlayerWidget
      // final musicPlayerWidget = ObjectFirebasePage(
      //   selectedKey: id.text,
      //   filePath: path, // Передача filePath
      // );
    } catch (error) {
      print('Error uploading file: $error');
    }
    setState(() {
      uploadAudioTask = null;
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
                controller: xCoordinateController,
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
                controller: yCoordinateController,
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
                        Text('Image URL: $myImageUrl'),
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
                child: Text('Select Photo'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10), // или любые другие отступы
              child: ElevatedButton(
                onPressed: uploadFile,
                child: Text('Upload Photo'),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Column(
              children: [
                if (pickedAudioFile != null)
                  Container(
                    color: Colors.green[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          color: Colors.green[200],
                          child: Text(pickedAudioFile!.path!),
                        ),
                        Text('Audio URL: $myAudioUrl'),
                        Container(
                          width: 200,
                          height: 200,
                          color: Colors.green[200],
                          child: Text(pathAudio),
                        ),
                        Text('Audio path: $pathAudio'),
                      ],
                    ),
                  ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10), // или любые другие отступы
              child: ElevatedButton(
                onPressed: selectAudioFile,
                child: Text('Select Audio'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10), // или любые другие отступы
              child: ElevatedButton(
                onPressed: uploadAudioFile,
                child: Text('Upload Audio'),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              margin: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  await updateFirebase(widget.selectedKey);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: const Text('Upadate data in databases'),
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
