import 'package:flutter/material.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/editFirebasePages.dart';
import 'package:mausoleum/pages/takeSearchFirebasepage.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';

class ObjectFirebasePage extends StatefulWidget {
  final String selectedKey; // Добавьте параметр для выбранного ключа
  final String currentLanguagekz; // Добавьте текущий языковой параметр
  final String currentLanguageru; // Добавьте текущий языковой параметр
  final String currentLanguageen; // Добавьте текущий языковой параметр


  ObjectFirebasePage({
    required this.selectedKey,
    required this.currentLanguagekz,
    required this.currentLanguageru,
    required this.currentLanguageen, // Добавьте текущий языковой параметр в конструктор
  });

  @override
  State<ObjectFirebasePage> createState() => _ObjectFirebasePageState();
}

class _ObjectFirebasePageState extends State<ObjectFirebasePage> {
  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    print("widget.selectedKey ${widget.selectedKey}");
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: whiteTextStyle,
          child: Container(
            color: Colors.amber,
            child: ListView(
              children: <Widget>[
                AppBar(
                  elevation: 0,
                  backgroundColor: Color.fromARGB(255, 83, 112, 85),
                  title: Text(
                    'mytitlepage'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 184, 182, 156),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: DropdawnFlag(
                        changedLanguage: (value) {
                          setState(() {
                            context.setLocale(Locale((value)));
                          });
                        },
                      ),
                    ),
                  ],
                ),
                mySearch(),
                Container(
                  height: MediaQuery.of(context).size.height - 163,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MyTextCont(selectedKey: widget.selectedKey),
                        ],
                      ),
                      MyPhotoCont(selectedKey: widget.selectedKey),
                      MyOverviews(
                        selectedKey: widget.selectedKey,
                        currentLanguagekz: widget.currentLanguagekz,
                        currentLanguageru: widget.currentLanguageru,
                        currentLanguageen: widget.currentLanguageen,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: MyCoordinate(
                    selectedKey: widget.selectedKey,
                  ),
                ),
                Container(
                  child: MenuTile(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0, bottom: 0.0),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditFirebasePage(
                      //editMydb: editMydb,
                      selectedKey: widget.selectedKey,
                    ),
                  ),
                );
              },
              mini: true, // Установите mini: true для уменьшения размера кнопки
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Настройте форму кнопки
              ),
              child: const Icon(Icons.create),
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrScanner(),
                ),
              );
            },
            child: const Icon(Icons.qr_code_scanner),
            mini: true, // Установите mini: true для уменьшения размера кнопки
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Настройте форму кнопки
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 0.0),
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );

                late CollectionReference<Map<String, dynamic>> collRef;
                if (Localizations.localeOf(context).languageCode == 'kk') {
                  collRef = FirebaseFirestore.instance.collection('datakz');
                } else if (Localizations.localeOf(context).languageCode ==
                    'ru') {
                  collRef = FirebaseFirestore.instance.collection('dataru');
                } else if (Localizations.localeOf(context).languageCode ==
                    'en') {
                  collRef = FirebaseFirestore.instance.collection('dataen');
                }
                String targetTitle =
                    widget.selectedKey; // Значение, которое вы ищете

                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    await collRef.get();
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    querySnapshot.docs;
                for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
                  Map<String, dynamic> autodata = doc.data();
                  String autokey = doc.id; // Получение ключа документа
                  // Проверка, соответствует ли поле title значению, которое вы ищете
                  if (autodata['title'] == targetTitle) {
                    await collRef.doc(autokey).delete();
                    print("Document deleted: $autokey");
                  }
                }
              },
              mini: true, // Установите mini: true для уменьшения размера кнопки
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Настройте форму кнопки
              ),
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class MyOverviews extends StatefulWidget {
  String selectedKey;
  final String currentLanguagekz; // Добавьте текущий языковой параметр
  final String currentLanguageru; // Добавьте текущий языковой параметр
  final String currentLanguageen; // Добавьте текущий языковой параметр

  MyOverviews({
    required this.selectedKey,
    required this.currentLanguagekz,
    required this.currentLanguageru,
    required this.currentLanguageen, // Добавьте текущий языковой параметр в конструктор
  });

  @override
  State<MyOverviews> createState() => MyOverviewsState();
}

class MyOverviewsState extends State<MyOverviews> {
  final whiteTextStyle =
      TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20);

  String discripWidgetsKz = "";
  String discripWidgetsRu = "";
  String discripWidgetsEn = "";
  String discripWidgetsEmpt = "";

  @override
  void initState() {
    super.initState();
    fetchKeysFirebase(); // Загрузите ключи из Firebase
  }

  Future<void> fetchKeysFirebase() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseen;
    late QuerySnapshot<Map<String, dynamic>> datakz;
    late QuerySnapshot<Map<String, dynamic>> dataru;
    late QuerySnapshot<Map<String, dynamic>> dataen;
    datakz = await FirebaseFirestore.instance.collection('datakz').get();
    dataru = await FirebaseFirestore.instance.collection('dataru').get();
    dataen = await FirebaseFirestore.instance.collection('dataen').get();

    datafirebasekz = datakz.docs.toList();
    datafirebaseru = dataru.docs.toList();
    datafirebaseen = dataen.docs.toList();

    late String autokey;
    late Map<String, dynamic> autodata;

    for (int i = 0; i < datafirebasekz.length; i++) {
      autokey = datafirebasekz[i].id;
      autodata = datafirebasekz[i].data() as Map<String, dynamic>;
      if (widget.selectedKey == datafirebasekz[i]['title']) {
        discripWidgetsKz = datafirebasekz[i]['description'];
        break;
      }
    }
    // if (discripWidgets.isEmpty && autokey == autokey) {
    //   discripWidgets = autodata['description'];
    // }

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokey = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      if (widget.selectedKey == datafirebaseru[i]['title']) {
        discripWidgetsRu = datafirebaseru[i]['description'];
        break;
      }
    }

    // if (discripWidgets.isEmpty && autokey == autokey) {
    //   discripWidgets = autodata['description'];
    // }

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokey = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      if (widget.selectedKey == datafirebaseen[i]['title']) {
        discripWidgetsEn = datafirebaseen[i]['description'];
        break;
      }
    }

    if (discripWidgetsKz.isEmpty &&
        discripWidgetsRu.isEmpty &&
        discripWidgetsEn.isEmpty &&
        autokey == autokey) {
      discripWidgetsEmpt = autodata['description'];
    }

    print("discripWidgetsKz $discripWidgetsKz");
    print("discripWidgetsRu $discripWidgetsRu");
    print("discripWidgetsEn $discripWidgetsEn");
    print("discripWidgetsEmpt $discripWidgetsEmpt");
  }

  Widget build(BuildContext context) {
    late Stream<QuerySnapshot<Map<String, dynamic>>> datastream;
    if (discripWidgetsKz != null) {
      Localizations.localeOf(context).languageCode == widget.currentLanguagekz;
      datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    } else if (discripWidgetsRu != null) {
      Localizations.localeOf(context).languageCode == widget.currentLanguageru;
      datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    } else if (discripWidgetsEn != null) {
      Localizations.localeOf(context).languageCode == widget.currentLanguageen;
      datastream = FirebaseFirestore.instance.collection('dataen').snapshots();
    }

    // datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    // datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    // datastream = FirebaseFirestore.instance.collection('dataen').snapshots();

    print("discripWidgetsKz $discripWidgetsKz");
    print("discripWidgetsRu $discripWidgetsRu");
    print("discripWidgetsEn $discripWidgetsEn");
    print("discripWidgets $discripWidgetsEmpt");

    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки во время ожидания данных
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        // fetchKeysFirebase();

        // String discripWidgets = "";
        // late String autokey;
        // late Map<String, dynamic> autodata;

        // final keysfirebase = snapshot.data?.docs.toList();

        // for (var key in keysfirebase!) {
        //   autokey = key.id;
        //   autodata = key.data() as Map<String, dynamic>;
        //   if (widget.selectedKey == key['title']) {
        //     discripWidgets = key['description'];
        //     print("key['title']2 ${key['title']}");
        //     break;
        //   }
        // }
        // print("widget.selectedKey2 ${widget.selectedKey}");

        // if (discripWidgets.isEmpty && autokey == autokey) {
        //   discripWidgets = autodata['description'];
        // }
        // print("discripWidgets $discripWidgets");

        return Container(
          color: Colors.amber,
          child: Text(
            discripWidgetsRu, // Убедиcь, что значение не null
            style: whiteTextStyle,
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }
}

class MyCoordinate extends StatefulWidget {
  String selectedKey;

  MyCoordinate({
    //required this.mapdata,
    required this.selectedKey,
  });

  @override
  State<MyCoordinate> createState() => MyCoordinateState();
}

class MyCoordinateState extends State<MyCoordinate> {
  final whiteTextStyle =
      TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20);

  Widget build(BuildContext context) {
    late Stream<QuerySnapshot<Map<String, dynamic>>> datastream;
    if (Localizations.localeOf(context).languageCode == 'kk') {
      datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'ru') {
      datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'en') {
      datastream = FirebaseFirestore.instance.collection('dataen').snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки во время ожидания данных
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        late double xCoordinateWidgets;
        late double yCoordinateWidgets;
        late String autokey;
        late Map<String, dynamic> autodata;
        final keysfirebase = snapshot.data?.docs.toList();

        for (var key in keysfirebase!) {
          autokey = key.id;
          autodata = key.data() as Map<String, dynamic>;
          if (widget.selectedKey == key['title']) {
            xCoordinateWidgets = key['xCoordinate'];
            yCoordinateWidgets = key['yCoordinate'];
            break;
          }
        }
        if (autokey == autokey) {
          xCoordinateWidgets = autodata['xCoordinate'];
          yCoordinateWidgets = autodata['yCoordinate'];
        }

        return Container(
          padding: const EdgeInsets.only(left: 50.0, bottom: 0.0),
          child: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MapControlsPage(
                    //editMydb: editMydb,
                    title: widget.selectedKey,
                    selectedX: xCoordinateWidgets,
                    selectedY: yCoordinateWidgets,
                  ),
                ),
              );
            },
            mini: true, // Установите mini: true для уменьшения размера кнопки
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Настройте форму кнопки
            ),
            child: const Icon(Icons.map),
          ),
        );
      },
    );
  }
}

class mySearch extends StatefulWidget {
  @override
  State<mySearch> createState() => _MySearchState();
}

TextEditingController keyword = TextEditingController();

class _MySearchState extends State<mySearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          controller: keyword,
          onSubmitted: (value) {
            setState(() {
              // ignore: unrelated_type_equality_checks
              keyword.text = value;
            });
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // setState(() {
                //   keywordAsyncFunction(keyword.text);
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (keyword.text != '') {
                        return takeSearchFirebasePage(
                            // resList: resList,
                            mykeyword: keyword.text);
                      } else {
                        return HomePage();
                      }
                    },
                  ),
                );
              },
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                keyword.text = '';
              },
            ),
            hintText: 'searchword'.tr(),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class MyTextCont extends StatefulWidget {
  String selectedKey;

  MyTextCont({required this.selectedKey});

  @override
  State<MyTextCont> createState() => _MyTextContState();
}

class _MyTextContState extends State<MyTextCont> {
  @override
  Widget build(BuildContext context) {
    late Stream<QuerySnapshot<Map<String, dynamic>>> datastream;
    if (Localizations.localeOf(context).languageCode == 'kk') {
      datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'ru') {
      datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'en') {
      datastream = FirebaseFirestore.instance.collection('dataen').snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки во время ожидания данных
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        String textWidgets = "";

        late String autokey;
        late Map<String, dynamic> autodata;

        final keysfirebase = snapshot.data?.docs.toList();
        for (var key in keysfirebase!) {
          autokey = key.id;
          autodata = key.data() as Map<String, dynamic>;
          if (widget.selectedKey == key['title']) {
            textWidgets = key['title'];
            break;
          }
        }
        if (textWidgets.isEmpty && autokey == autokey) {
          textWidgets = autodata['title'];
        }

        print(textWidgets);
        return Container(
          width: 350,
          alignment: Alignment.center,
          color: Colors.amber,
          child: Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
            color: Colors.amber,
            child: Text(
              textWidgets,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyPhotoCont extends StatefulWidget {
  String selectedKey;

  MyPhotoCont({
    required this.selectedKey,
  });

  @override
  State<MyPhotoCont> createState() => _MyPhotoContState();
}

class _MyPhotoContState extends State<MyPhotoCont> {
  @override
  Widget build(BuildContext context) {
    late Stream<QuerySnapshot<Map<String, dynamic>>> datastream;
    if (Localizations.localeOf(context).languageCode == 'kk') {
      datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'ru') {
      datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    } else if (Localizations.localeOf(context).languageCode == 'en') {
      datastream = FirebaseFirestore.instance.collection('dataen').snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки во время ожидания данных
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        String photoWidgets = "";
        late String autokey;
        late Map<String, dynamic> autodata;

        final keysfirebase = snapshot.data?.docs.toList();
        for (var key in keysfirebase!) {
          autokey = key.id;
          autodata = key.data() as Map<String, dynamic>;
          if (widget.selectedKey == key['title']) {
            photoWidgets = key['filephotopath'];
            break;
          }
        }
        if (photoWidgets.isEmpty && autokey == autokey) {
          photoWidgets = autodata['filephotopath'];
        }

        print(photoWidgets);
        return Container(
          height: 150,
          width: 340,
          child: Card(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              //child: Text('No image'),
              child: Image.file(
                File(photoWidgets),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuTile extends StatefulWidget {
  @override
  MenuTileWidget createState() => MenuTileWidget();
}

class MenuTileWidget extends State<MenuTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 0),
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(0),
            child: Container(
              color: Color.fromARGB(255, 67, 83, 68),
              padding: const EdgeInsets.all(10),
              child: _buildAction(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 67, 83, 68),
        border: Border.all(),
      ),
    );
  }

  Widget _buildAction() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButton("myhomepage".tr(), Icons.home, Colors.black),
          _buildButton("myQR".tr(), Icons.qr_code, Colors.black),
          _buildButton("mymap".tr(), Icons.map, Colors.black),
        ],
      );

  Widget _buildButton(
    String label,
    IconData icon,
    Color color,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.deepOrange,
          ),
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
}
