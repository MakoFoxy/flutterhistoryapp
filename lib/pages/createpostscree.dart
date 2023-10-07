import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';

class CreateHistoryPost extends StatefulWidget {
  @override
  State<CreateHistoryPost> createState() => _CreateHistoryPostState();
}

class _CreateHistoryPostState extends State<CreateHistoryPost> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String myImageUrl = "";

  PlatformFile? pickedAudioFileKz;
  UploadTask? uploadAudioTaskKz;
  String myAudioUrlKz = "";
  String pathAudioKz = "";

  PlatformFile? pickedAudioFileRu;
  UploadTask? uploadAudioTaskRu;
  String myAudioUrlRu = "";
  String pathAudioRu = "";

  PlatformFile? pickedAudioFileEn;
  UploadTask? uploadAudioTaskEn;
  String myAudioUrlEn = "";
  String pathAudioEn = "";

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

  Future selectAudioFileKz() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      pickedAudioFileKz = fileres.files.first;
    });

    print("result $result");
    print("pickedAudioFileKz $pickedAudioFileKz");
  }

  Future uploadAudioFileKz() async {
    pathAudioKz = 'files/${pickedAudioFileKz!.path!}';
    final fileupload = File(pickedAudioFileKz!.path!);

    final dataref = FirebaseStorage.instance.ref().child(pathAudioKz);
    setState(() {
      uploadAudioTaskKz = dataref.putFile(fileupload);
    });
    print('Upload uploadAudioTaskKz $uploadAudioTaskKz');
    try {
      // final snapshot = await uploadAudioTask!.whenComplete(() {});
      // print('Upload snapshot $snapshot');
      final urlAudioDownload = await dataref.getDownloadURL();
      myAudioUrlKz = urlAudioDownload;
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
      uploadAudioTaskKz = null;
    });
  }

  Future selectAudioFileRu() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      pickedAudioFileRu = fileres.files.first;
    });

    print("result $result");
    print("pickedAudioFileRu $pickedAudioFileRu");
  }

  Future uploadAudioFileRu() async {
    pathAudioRu = 'files/${pickedAudioFileRu!.path!}';
    final fileupload = File(pickedAudioFileRu!.path!);

    final dataref = FirebaseStorage.instance.ref().child(pathAudioRu);
    setState(() {
      uploadAudioTaskRu = dataref.putFile(fileupload);
    });
    print('Upload uploadAudioTaskRu $uploadAudioTaskRu');
    try {
      // final snapshot = await uploadAudioTask!.whenComplete(() {});
      // print('Upload snapshot $snapshot');
      final urlAudioDownload = await dataref.getDownloadURL();
      myAudioUrlRu = urlAudioDownload;
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
      uploadAudioTaskRu = null;
    });
  }

  Future selectAudioFileEn() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      initialDirectory: '/storage/emulated/0/Download',
    );

    final fileres = await FilePicker.platform.pickFiles();
    if (fileres == null) return;

    setState(() {
      pickedAudioFileEn = fileres.files.first;
    });

    print("result $result");
    print("pickedAudioFileEn $pickedAudioFileEn");
  }

  Future uploadAudioFileEn() async {
    pathAudioEn = 'files/${pickedAudioFileEn!.path!}';
    final fileupload = File(pickedAudioFileEn!.path!);

    final dataref = FirebaseStorage.instance.ref().child(pathAudioEn);
    setState(() {
      uploadAudioTaskEn = dataref.putFile(fileupload);
    });
    print('Upload uploadAudioTaskEn $uploadAudioTaskEn');
    try {
      // final snapshot = await uploadAudioTask!.whenComplete(() {});
      // print('Upload snapshot $snapshot');
      final urlAudioDownload = await dataref.getDownloadURL();
      myAudioUrlEn = urlAudioDownload;
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
      uploadAudioTaskEn = null;
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
                  if (pickedAudioFileKz != null)
                    Container(
                      color: Colors.green[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pickedAudioFileKz!.path!),
                          ),
                          Text('Audio KZ URL: $myAudioUrlKz'),
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pathAudioKz),
                          ),
                          Text('Audio KZ path: $pathAudioKz'),
                        ],
                      ),
                    ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: selectAudioFileKz,
                  child: Text('Select KZ Audio'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: uploadAudioFileKz,
                  child: Text('Upload KZ Audio'),
                ),
              ),

              Column(
                children: [
                  if (pickedAudioFileRu != null)
                    Container(
                      color: Colors.green[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pickedAudioFileRu!.path!),
                          ),
                          Text('Audio RU URL: $myAudioUrlRu'),
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pathAudioRu),
                          ),
                          Text('Audio RU path: $pathAudioRu'),
                        ],
                      ),
                    ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: selectAudioFileRu,
                  child: Text('Select RU Audio'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: uploadAudioFileRu,
                  child: Text('Upload RU Audio'),
                ),
              ),

              Column(
                children: [
                  if (pickedAudioFileEn != null)
                    Container(
                      color: Colors.green[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pickedAudioFileEn!.path!),
                          ),
                          Text('Audio EN URL: $myAudioUrlEn'),
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.green[200],
                            child: Text(pathAudioEn),
                          ),
                          Text('Audio EN path: $pathAudioEn'),
                        ],
                      ),
                    ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: selectAudioFileEn,
                  child: Text('Select En Audio'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10), // или любые другие отступы
                child: ElevatedButton(
                  onPressed: uploadAudioFileEn,
                  child: Text('Upload EN Audio'),
                ),
              ),

              //buildProgress(),
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
                      'fileaudiopathkz': myAudioUrlKz,
                      'firebaseaudiopathkz': pathAudioKz,
                    };
                    Map<String, dynamic> dataru = {
                      'id': id.text,
                      'title': teTitleRu.text,
                      'description': teDescriptionRu.text,
                      'xCoordinate': xCoordinateInt,
                      'yCoordinate': yCoordinateInt,
                      'filephotopath': myImageUrl,
                      'fileaudiopathru': myAudioUrlRu,
                      'firebaseaudiopathru': pathAudioRu,
                    };
                    Map<String, dynamic> dataen = {
                      'id': id.text,
                      'title': teTitleEn.text,
                      'description': teDescriptionEn.text,
                      'xCoordinate': xCoordinateInt,
                      'yCoordinate': yCoordinateInt,
                      'filephotopath': myImageUrl,
                      'fileaudiopathen': myAudioUrlEn,
                      'firebaseaudiopathen': pathAudioEn,
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
                    pickedAudioFileKz = null;
                    pickedAudioFileRu = null;
                    pickedAudioFileEn = null;
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
