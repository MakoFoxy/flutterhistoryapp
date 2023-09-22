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

class QRobjectpage extends StatefulWidget {
  final String selectedKey; // Добавьте параметр для выбранного ключа
  final Function() closeScreen;

  QRobjectpage({
    super.key,
    required this.closeScreen,
    required this.selectedKey,
  });

  @override
  State<QRobjectpage> createState() => QRobjectpageState();
}

class QRobjectpageState extends State<QRobjectpage> {
  String currentSelectedKey = ''; // Инициализируйте переменную пустым значением
  int _backPressCount = 0;
  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_backPressCount == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
          return false;
        } else {
          // Переход на домашнюю страницу и сброс счетчика
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
          return false; // Запрещаем закрытие приложения
        }
      },
      child: Scaffold(
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
                        child: DropdownFlag(
                          changedLanguage: (value) {
                            setState(() {
                              currentSelectedKey =
                                  value; // Обновляем текущий выбранный ключ
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
                            //MyPhotoCont(),
                          ],
                        ),
                        MyPhotoCont(selectedKey: widget.selectedKey),
                        MyOverviews(selectedKey: widget.selectedKey),
                      ],
                    ),
                  ),               
                  Container(
                    child: MenuTile(
                      selectedKey: widget.selectedKey,
                    ),
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
                  late String keyforedit;
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
                  for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                      in docs) {
                    Map<String, dynamic> autodata = doc.data();
                    String autokey = doc.id; // Получение ключа документа
                    // Проверка, соответствует ли поле title значению, которое вы ищете
                    if (autodata['id'] == targetTitle) {
                      keyforedit = autodata['id'];
                    }
                  }
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditFirebasePage(
                        //editMydb: editMydb,
                        selectedKey: keyforedit,
                      ),
                    ),
                  );
                  await widget.closeScreen();
                },
                mini:
                    true, // Установите mini: true для уменьшения размера кнопки
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Настройте форму кнопки
                ),
                child: const Icon(Icons.create),
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
                  for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                      in docs) {
                    Map<String, dynamic> autodata = doc.data();
                    String autokey = doc.id; // Получение ключа документа
                    // Проверка, соответствует ли поле title значению, которое вы ищете
                    if (autodata['id'] == targetTitle) {
                      await collRef.doc(autokey).delete();
                      print("Document deleted: $autokey");
                    }
                  }
                },
                mini:
                    true, // Установите mini: true для уменьшения размера кнопки
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
      ),
    );
  }
}

class MyOverviews extends StatefulWidget {
  String selectedKey;
  // final String currentLanguagekz; // Добавьте текущий языковой параметр
  // final String currentLanguageru; // Добавьте текущий языковой параметр
  // final String currentLanguageen; // Добавьте текущий языковой параметр

  MyOverviews({
    required this.selectedKey,
    // required this.currentLanguagekz,
    // required this.currentLanguageru,
    // required this.currentLanguageen, // Добавьте текущий языковой параметр в конструктор
  });

  @override
  State<MyOverviews> createState() => MyOverviewsState();
}

class MyOverviewsState extends State<MyOverviews> {
  final whiteTextStyle =
      TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20);

  late List<String> discripWidgetsArr = [];
  String id = "";
  String discripWidgetsKz = "";
  String discripWidgetsRu = "";
  String discripWidgetsEn = "";
  String discripWidgetsEmpt = "";

  @override
  Future<List<String>> fetchKeysFirebaseOver() async {
    List<String> arrlen = [];
    arrlen.add(widget.selectedKey);
    print("widget.selectedKey from firebase ${arrlen.length}");

    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseen;
    late QuerySnapshot<Map<String, dynamic>> datakz;
    late QuerySnapshot<Map<String, dynamic>> dataru;
    late QuerySnapshot<Map<String, dynamic>> dataen;
    dataru = await FirebaseFirestore.instance.collection('dataru').get();
    datakz = await FirebaseFirestore.instance.collection('datakz').get();
    dataen = await FirebaseFirestore.instance.collection('dataen').get();

    datafirebasekz = datakz.docs.toList();
    datafirebaseru = dataru.docs.toList();
    datafirebaseen = dataen.docs.toList();

    late String autokey;

    late Map<String, dynamic> autodata;
    for (int i = 0; i < datafirebasekz.length; i++) {
      autokey = datafirebasekz[i].id;
      autodata = datafirebasekz[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']KZ from firebase ${datafirebasekz[i]['title']}");
      if (widget.selectedKey == datafirebasekz[i]['id'] &&
          !discripWidgetsArr.contains(discripWidgetsKz)) {
        discripWidgetsKz = datafirebasekz[i]['description'];
        discripWidgetsArr.add(discripWidgetsKz);
        break;
      }
    }

    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokey = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseru[i]['title']RU from firebase ${datafirebaseru[i]['title']}");
      if (widget.selectedKey == datafirebaseru[i]['id'] &&
          !discripWidgetsArr.contains(discripWidgetsRu)) {
        discripWidgetsRu = datafirebaseru[i]['description'];
        print("discripWidgetsRu $discripWidgetsRu");
        discripWidgetsArr.add(discripWidgetsRu);
        break;
      }
    }
    print("autokeyru $autokey");

    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokey = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']EN from firebase ${datafirebaseen[i]['title']}");
      if (widget.selectedKey == datafirebaseen[i]['id'] &&
          !discripWidgetsArr.contains(discripWidgetsEn)) {
        discripWidgetsEn = datafirebaseen[i]['description'];
        print("discripWidgetsEn $discripWidgetsEn");
        discripWidgetsArr.add(discripWidgetsEn);
        break;
      }
      print("widget.selectedKeyEN ${widget.selectedKey}");
    }
    //print("discripWidgetsEn from firebase $discripWidgetsEn");
    print("autokeyen $autokey");

    if (discripWidgetsKz.isEmpty &&
        discripWidgetsRu.isEmpty &&
        discripWidgetsEn.isEmpty &&
        autokey == autokey) {
      discripWidgetsEmpt = autodata['description'];
      discripWidgetsArr.add(discripWidgetsEmpt);
    }

    print("discripWidgetsKz***************${discripWidgetsKz}");
    print("discripWidgetsEn***************${discripWidgetsEn}");
    print("discripWidgetsRu***************${discripWidgetsRu}");
    print("discripWidgetsEmpt***************${discripWidgetsEmpt}");
    //print("********************\n${discripWidgetsEn.toString()}");
    print("discripWidgetsArr $discripWidgetsArr");
    print("discripWidgetsArr.length ${discripWidgetsArr.length}");

    return discripWidgetsArr;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchKeysFirebaseOver(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final List<String> discripWidgetsArr = snapshot.data ?? [];
        print("***<=>discripWidgetsArr $discripWidgetsArr");

        print("****<=>discripWidgetsArr.length ${discripWidgetsArr.length}");

        print("******<=>widget.selectedKey ${widget.selectedKey}");

        String discripWidgetsKaz = "";
        String discripWidgetsRus = "";
        String discripWidgetsEng = "";
        String discripWidgetsEmpty = "";

        print("discripWidgetsArr ${discripWidgetsArr.length}");

        discripWidgetsArr.forEach((element) {
          if (discripWidgetsKz == element) {
            discripWidgetsKaz = discripWidgetsKaz + element;
          } else if (discripWidgetsRu == element) {
            discripWidgetsRus = discripWidgetsRus + element;
          } else if (discripWidgetsEn == element) {
            discripWidgetsEng = discripWidgetsEng + element;
          } else {
            discripWidgetsEmpty = discripWidgetsEmpty + element;
          }
          print("***<=>element $element");
        });

        discripWidgetsArr.clear();
        String displayedText = "";

        if (discripWidgetsKaz.isNotEmpty &&
            Localizations.localeOf(context).languageCode == 'kk') {
          displayedText = discripWidgetsKaz;
        } else if (discripWidgetsRus.isNotEmpty &&
            Localizations.localeOf(context).languageCode == 'ru') {
          displayedText = discripWidgetsRus;
        } else if (discripWidgetsEng.isNotEmpty &&
            Localizations.localeOf(context).languageCode == 'en') {
          displayedText = discripWidgetsEng;
        } else {
          displayedText = discripWidgetsEmpty;
        }

        print("displayedText  $displayedText");
        print("discripWidgetsArr clear $discripWidgetsArr");
        print("discripWidgetsKaz $discripWidgetsKaz");
        print("discripWidgetsRus $discripWidgetsRus");
        print("discripWidgetsEng $discripWidgetsEng");
        print("discripWidgetsEmpty $discripWidgetsEmpty");

        return Container(
          color: Colors.amber,
          child: Text(
            displayedText, // Make sure the value is not null
            style: whiteTextStyle,
            textAlign: TextAlign.justify,
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
            // prefixIcon: IconButton(
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     // setState(() {
            //     //   keywordAsyncFunction(keyword.text);
            //     // });
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           if (keyword.text != '') {
            //             return takeSearchFirebasePage(
            //                 // resList: resList,
            //                 mykeyword: keyword.text,
            //                 takekeywordText: keywordTextObj);
            //           } else {
            //             return HomePage();
            //           }
            //         },
            //       ),
            //     );
            //   },
            // ),
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
  List<String> titleWidgetsArr = [];
  String titleWidgetsKz = "";
  String titleWidgetsRu = "";
  String titleWidgetsEn = "";
  String titleWidgetsEmpt = "";

  // @override
  // void initState() {
  //   super.initState();
  //   // Вызываем fetchKeysFirebase() только один раз при инициализации виджета
  //   fetchKeysFirebaseText();
  // }

  Future<List<String>> fetchKeysFirebaseText() async {
    List<String> arrlen = [];
    arrlen.add(widget.selectedKey);
    print("widget.selectedKey from firebase ${arrlen.length}");

    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseen;
    late QuerySnapshot<Map<String, dynamic>> datakz;
    late QuerySnapshot<Map<String, dynamic>> dataru;
    late QuerySnapshot<Map<String, dynamic>> dataen;
    dataru = await FirebaseFirestore.instance.collection('dataru').get();
    datakz = await FirebaseFirestore.instance.collection('datakz').get();
    dataen = await FirebaseFirestore.instance.collection('dataen').get();

    datafirebasekz = datakz.docs.toList();
    datafirebaseru = dataru.docs.toList();
    datafirebaseen = dataen.docs.toList();

    late String autokey;
    late Map<String, dynamic> autodata;

    for (int i = 0; i < datafirebasekz.length; i++) {
      autokey = datafirebasekz[i].id;
      autodata = datafirebasekz[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']KZ from firebase ${datafirebasekz[i]['title']}");
      print('QRwidget.selectedKey start ${widget.selectedKey}');
      print('autokey start $autokey');
      if (widget.selectedKey == datafirebasekz[i]['id'] &&
          !titleWidgetsArr.contains(titleWidgetsKz)) {
        print('QRwidget.selectedKey finish ${widget.selectedKey}');
        print('autokey finish $autokey');
        titleWidgetsKz = datafirebasekz[i]['title'];
        titleWidgetsArr.add(titleWidgetsKz);
        break;
      }
    }
    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokey = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseru[i]['title']RU from firebase ${datafirebaseru[i]['title']}");
      if (widget.selectedKey == datafirebaseru[i]['id'] &&
          !titleWidgetsArr.contains(titleWidgetsRu)) {
        titleWidgetsRu = datafirebaseru[i]['title'];
        titleWidgetsArr.add(titleWidgetsRu);
        break;
      }
    }

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokey = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseen[i]['title']EN from firebase ${datafirebaseen[i]['title']}");
      if (widget.selectedKey == datafirebaseen[i]['id'] &&
          !titleWidgetsArr.contains(titleWidgetsEn)) {
        titleWidgetsEn = datafirebaseen[i]['title'];
        titleWidgetsArr.add(titleWidgetsEn);
        break;
      }
    }

    if (titleWidgetsKz.isEmpty &&
        titleWidgetsRu.isEmpty &&
        titleWidgetsEn.isEmpty &&
        autokey == autokey) {
      titleWidgetsEmpt = autodata['title'];
      titleWidgetsArr.add(titleWidgetsEmpt);
    }

    print("QRtitleWidgetsKz***${titleWidgetsKz}");
    print("QRtitleWidgetsEn***${titleWidgetsEn}");
    print("QRtitleWidgetsRu***${titleWidgetsRu}");
    print("QRtitleWidgetsEmpt**${titleWidgetsEmpt}");
    print("QRtitleWidgetsArr $titleWidgetsArr");
    print("QRtitleWidgetsArr.length ${titleWidgetsArr.length}");

    return titleWidgetsArr;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      // Pass the Future that will return data after executing fetchKeysFirebase()
      future: fetchKeysFirebaseText(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        // If data is loaded successfully, display it
        final List<String> titleWidgetsArr = snapshot.data ?? [];
        print("<=>titleWidgetsArr $titleWidgetsArr");

        print("<=>titleWidgetsArr.length ${titleWidgetsArr.length}");

        print("<=>widget.selectedKey ${widget.selectedKey}");

        String titleWidgetsKaz = "";
        String titleWidgetsRus = "";
        String titleWidgetsEng = "";
        String titleWidgetsEmpty = "";

        titleWidgetsArr.forEach((element) {
          if (titleWidgetsKz == element) {
            titleWidgetsKaz = titleWidgetsKaz + element;
          } else if (titleWidgetsRu == element) {
            titleWidgetsRus = titleWidgetsRus + element;
          } else if (titleWidgetsEn == element) {
            titleWidgetsEng = titleWidgetsEng + element;
          } else {
            titleWidgetsEmpty = titleWidgetsEmpty + element;
          }
          print("<=>element $element");
        });

        titleWidgetsArr.clear();
        print("titleWidgetsArr.clear $titleWidgetsArr");

        String currentLanguagekz = 'kk';
        String currentLanguageru = 'ru';
        String currentLanguageen = 'en';
        String titledisplayedText = "";

        if (Localizations.localeOf(context).languageCode == currentLanguagekz) {
          //fetchKeysFirebaseText();
          if (titleWidgetsKaz.isNotEmpty) {
            titledisplayedText = titleWidgetsKaz;
          }
        } else if (Localizations.localeOf(context).languageCode ==
            currentLanguageru) {
          // fetchKeysFirebaseText();
          if (titleWidgetsRus.isNotEmpty) {
            titledisplayedText = titleWidgetsRus;
          }
        } else if (Localizations.localeOf(context).languageCode ==
            currentLanguageen) {
          // fetchKeysFirebaseText;
          if (titleWidgetsEng.isNotEmpty) {
            titledisplayedText = titleWidgetsEng;
          }
        } else {
          titledisplayedText = titleWidgetsEmpty;
        }

        print("titleWidgetsKaz $titleWidgetsKaz");
        print("titleWidgetsRus $titleWidgetsRus");
        print("titleWidgetsEng $titleWidgetsEng");
        print("titleWidgetsEmpty $titleWidgetsEmpty");

        return Container(
          width: 350,
          alignment: Alignment.center,
          color: Colors.amber,
          child: Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
            color: Colors.amber,
            child: Text(
              titledisplayedText,
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
  List<String> photoWidgetsArr = [];
  String photoWidgetsKz = "";
  String photoWidgetsRu = "";
  String photoWidgetsEn = "";
  String photoWidgetsEmpt = "";

  @override
  Future<List<String>> fetchKeysFirebasePhoto() async {
    List<String> arrlen = [];
    arrlen.add(widget.selectedKey);
    print("widget.selectedKey from firebase ${arrlen.length}");

    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseen;
    late QuerySnapshot<Map<String, dynamic>> datakz;
    late QuerySnapshot<Map<String, dynamic>> dataru;
    late QuerySnapshot<Map<String, dynamic>> dataen;
    dataru = await FirebaseFirestore.instance.collection('dataru').get();
    datakz = await FirebaseFirestore.instance.collection('datakz').get();
    dataen = await FirebaseFirestore.instance.collection('dataen').get();

    datafirebasekz = datakz.docs.toList();
    datafirebaseru = dataru.docs.toList();
    datafirebaseen = dataen.docs.toList();

    late String autokey;
    late Map<String, dynamic> autodata;

    for (int i = 0; i < datafirebasekz.length; i++) {
      autokey = datafirebasekz[i].id;
      autodata = datafirebasekz[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']KZ from firebase ${datafirebasekz[i]['title']}");
      if (widget.selectedKey == datafirebasekz[i]['id'] &&
          !photoWidgetsArr.contains(photoWidgetsKz)) {
        photoWidgetsKz = datafirebasekz[i]['filephotopath'];
        photoWidgetsArr.add(photoWidgetsKz);
        break;
      }
    }

    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokey = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseru[i]['title']RU from firebase ${datafirebaseru[i]['title']}");
      if (widget.selectedKey == datafirebaseru[i]['id'] &&
          !photoWidgetsArr.contains(photoWidgetsRu)) {
        photoWidgetsRu = datafirebaseru[i]['filephotopath'];
        photoWidgetsArr.add(photoWidgetsRu);
        break;
      }
    }

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokey = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']EN from firebase ${datafirebaseen[i]['title']}");
      if (widget.selectedKey == datafirebaseen[i]['id'] &&
          !photoWidgetsArr.contains(photoWidgetsEn)) {
        photoWidgetsEn = datafirebaseen[i]['filephotopath'];
        photoWidgetsArr.add(photoWidgetsEn);
        break;
      }
    }

    if (photoWidgetsKz.isEmpty &&
        photoWidgetsRu.isEmpty &&
        photoWidgetsEn.isEmpty &&
        autokey == autokey) {
      photoWidgetsEmpt = autodata['filephotopath'];
      photoWidgetsArr.add(photoWidgetsEmpt);
    }

    print("photoWidgetsKz***************${photoWidgetsKz}");
    print("photoWidgetsEn***************${photoWidgetsEn}");
    print("photoWidgetsRu***************${photoWidgetsRu}");
    print("photoWidgetsEmpt***************${photoWidgetsEmpt}");
    print("photoWidgetsArr $photoWidgetsArr");
    print("photoWidgetsArr.length ${photoWidgetsArr.length}");

    return photoWidgetsArr;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      // Pass the Future that will return data after executing fetchKeysFirebase()
      future: fetchKeysFirebasePhoto(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        // If data is loaded successfully, display it
        final List<String> photoWidgetsArr = snapshot.data ?? [];
        print("*******************<=>photoWidgetsArr $photoWidgetsArr");

        print(
            "*******************<=>photoWidgetsArr.length ${photoWidgetsArr.length}");

        print("*******************<=>widget.selectedKey ${widget.selectedKey}");

        String photoWidgetsKaz = "";
        String photoWidgetsRus = "";
        String photoWidgetsEng = "";
        String photoWidgetsEmpty = "";

        String photoDisplayed = "";
        String currentLanguagekz = 'kk';
        String currentLanguageru = 'ru';
        String currentLanguageen = 'en';

        photoWidgetsArr.forEach((element) {
          if (photoWidgetsKz == element) {
            photoWidgetsKaz = photoWidgetsKaz + element;
          } else if (photoWidgetsRu == element) {
            photoWidgetsRus = photoWidgetsRus + element;
          } else if (photoWidgetsEn == element) {
            photoWidgetsEng = photoWidgetsEng + element;
          } else {
            photoWidgetsEmpty = photoWidgetsEmpty + element;
          }
          print("*******************<=>element $element");
        });

        //photoWidgetsArr.clear();

        if (Localizations.localeOf(context).languageCode == currentLanguagekz) {
          // fetchKeysFirebase();
          if (photoWidgetsKaz.isNotEmpty) {
            photoDisplayed = photoWidgetsKaz;
          }
        } else if (Localizations.localeOf(context).languageCode ==
            currentLanguageru) {
          // fetchKeysFirebase();
          if (photoWidgetsRus.isNotEmpty) {
            photoDisplayed = photoWidgetsRus;
          }
        } else if (Localizations.localeOf(context).languageCode ==
            currentLanguageen) {
          // fetchKeysFirebase;
          if (photoWidgetsEng.isNotEmpty) {
            photoDisplayed = photoWidgetsEng;
          }
        } else {
          photoDisplayed = photoWidgetsEmpty;
        }

        print("photoWidgetsKaz $photoWidgetsKaz");
        print("photoWidgetsRus $photoWidgetsRus");
        print("photoWidgetsEng $photoWidgetsEng");
        print("photoWidgetsEmpty $photoWidgetsEmpty");

        print(photoDisplayed);
        return Container(
          height: 150,
          width: 340,
          child: Card(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/mavzoley_yasavi.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Image.file(
              //   File(photoDisplayed),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        );
      },
    );
  }
}

class MenuTile extends StatefulWidget {
  String selectedKey;

  MenuTile({
    //required this.mapdata,
    required this.selectedKey,
  });
  @override
  MenuTileWidget createState() => MenuTileWidget();
}

class MenuTileWidget extends State<MenuTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(0),
            child: Container(
              color: Colors.white70,
              padding: const EdgeInsets.all(0),
              child: _buildAction(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
      ),
    );
  }

  Widget _buildAction() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildButtonHomePage("myhomepage".tr(), Icons.home, Colors.black),
          _buildButtonQR("myQR".tr(), Icons.qr_code, Colors.black),
          _buildButtonMap("mymap".tr(), Icons.map, Colors.black, this.context),
        ],
      );

  Widget _buildButtonMap(
      String label, IconData icon, Color color, BuildContext context) {
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
          if (widget.selectedKey == key['id']) {
            xCoordinateWidgets = key['xCoordinate'];
            yCoordinateWidgets = key['yCoordinate'];
            break;
          }
        }
        if (autokey == autokey) {
          xCoordinateWidgets = autodata['xCoordinate'];
          yCoordinateWidgets = autodata['yCoordinate'];
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MapControlsPage(
                      //editMydb: editMydb,
                      id: widget.selectedKey,
                      selectedX: xCoordinateWidgets,
                      selectedY: yCoordinateWidgets,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.map),
            ),
            Container(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonQR(
    String label,
    IconData icon,
    Color color,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () async {
              await Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => QrScanner(),
                ),
              );
            },
            child: const Icon(Icons.qr_code_scanner),
          ),
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );

  Widget _buildButtonHomePage(
    String label,
    IconData icon,
    Color color,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () async {
              await Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            child: const Icon(Icons.home),
          ),
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
}
