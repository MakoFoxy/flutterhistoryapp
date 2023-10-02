import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateHistoryPost extends StatefulWidget {
  @override
  State<CreateHistoryPost> createState() => _CreateHistoryPostState();
}

class _CreateHistoryPostState extends State<CreateHistoryPost> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String myImageUrl = "";

  PlatformFile? pickedAudioFile;
  UploadTask? uploadAudioTask;
  String myAudioUrl = "";

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

    final dataref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = dataref.putFile(fileupload);
    });
    print('Upload uploadTask $uploadTask');

    try {
      // final snapshot = await uploadTask!.whenComplete(() {});
      // print('Upload snapshot $snapshot');
      final urlDownload = await dataref.getDownloadURL();
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
    final path = 'files/${pickedAudioFile!.path!}';
    final fileupload = File(pickedAudioFile!.path!);

    final dataref = FirebaseStorage.instance.ref().child(path);
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
    } catch (error) {
      print('Error uploading file: $error');
    }
    setState(() {
      uploadAudioTask = null;
    });
  }

  TextEditingController id = TextEditingController();

  TextEditingController teTitleKz = TextEditingController();

  TextEditingController teDescriptionKz = TextEditingController();

  TextEditingController teTitleRu = TextEditingController();

  TextEditingController teDescriptionRu = TextEditingController();

  TextEditingController teTitleEn = TextEditingController();

  TextEditingController teDescriptionEn = TextEditingController();

  TextEditingController xCoordinate = TextEditingController();

  TextEditingController yCoordinate = TextEditingController();

  late double xCoordinateInt;
  late double yCoordinateInt;

  position(xCoordinate, yCoordinate) {
    xCoordinateInt = double.parse(xCoordinate.text);
    yCoordinateInt = double.parse(yCoordinate.text);
  }

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
                  top: 10,
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
                  top: 10,
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
                  top: 10,
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
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  controller: teDescriptionKz,
                  decoration: const InputDecoration(
                    hintText: 'Сиппатама',
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
                  controller: teDescriptionRu,
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
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  controller: teDescriptionEn,
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
                    position(xCoordinate, yCoordinate);
                    CollectionReference collRefKz =
                        FirebaseFirestore.instance.collection('datakz');
                    CollectionReference collRefRu =
                        FirebaseFirestore.instance.collection('dataru');
                    CollectionReference collRefEn =
                        FirebaseFirestore.instance.collection('dataen');
                    Map<String, dynamic> datakz = {
                      'id': id.text,
                      'title': teTitleKz.text,
                      'description': teDescriptionKz.text,
                      'xCoordinate': xCoordinateInt,
                      'yCoordinate': yCoordinateInt,
                      'filephotopath': myImageUrl,
                      'fileaudiopath': myAudioUrl,
                    };
                    Map<String, dynamic> dataru = {
                      'id': id.text,
                      'title': teTitleRu.text,
                      'description': teDescriptionRu.text,
                      'xCoordinate': xCoordinateInt,
                      'yCoordinate': yCoordinateInt,
                      'filephotopath': myImageUrl,
                      'fileaudiopath': myAudioUrl,
                    };
                    Map<String, dynamic> dataen = {
                      'id': id.text,
                      'title': teTitleEn.text,
                      'description': teDescriptionEn.text,
                      'xCoordinate': xCoordinateInt,
                      'yCoordinate': yCoordinateInt,
                      'filephotopath': myImageUrl,
                      'fileaudiopath': myAudioUrl,
                    };

                    DocumentReference docRefKz = await collRefKz.add(datakz);
                    DocumentReference docRefRu = await collRefRu.add(dataru);
                    DocumentReference docRefEn = await collRefEn.add(dataen);

                    String parentKeyKz = docRefKz.parent.id;
                    String parentKeyRu = docRefRu.parent.id;
                    String parentKeyEn = docRefEn.parent.id;

                    print('parentKeyKz $parentKeyKz');
                    print('parentKeyRu $parentKeyRu');
                    print('parentKeyEn $parentKeyEn');

                    id.clear();
                    teTitleKz.clear();
                    teTitleRu.clear();
                    teTitleEn.clear();
                    teDescriptionKz.clear();
                    teDescriptionRu.clear();
                    teDescriptionEn.clear();

                    pickedFile = null;

                    Navigator.pop(context);
                  },
                  child: const Text('Save data in database'),
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
