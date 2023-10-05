import 'package:flutter/material.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mausoleum/pages/editFirebasePages.dart';
import 'package:mausoleum/pages/takeSearchFirebasepage.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mausoleum/pages/slider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class QRobjectpage extends StatefulWidget {
  final String selectedKey; // Добавьте параметр для выбранного ключа

  QRobjectpage({
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
        if (_audioPlayer.playing) {
          _audioPlayer.stop(); // Остановите аудиоплеер
        }
        if (_backPressCount == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
          return false;
        } else {
          // exit(0);
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
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Set your preferred height here
          child: MyAppBar(), // Use your custom app bar
        ),
        body: SafeArea(
          child: DefaultTextStyle(
            style: whiteTextStyle,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 125,
                    child: ListView(
                      children: <Widget>[
                        MyPhotoCont(selectedKey: widget.selectedKey),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MyTextCont(selectedKey: widget.selectedKey),
                            //MyPhotoCont(),
                          ],
                        ),
                        MusicPlayerWidget(selectedKey: widget.selectedKey),
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
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //           late String keyforedit;
        //           late CollectionReference<Map<String, dynamic>> collRef;
        //           if (Localizations.localeOf(context).languageCode == 'kk') {
        //             collRef = FirebaseFirestore.instance.collection('datakz');
        //           } else if (Localizations.localeOf(context).languageCode ==
        //               'ru') {
        //             collRef = FirebaseFirestore.instance.collection('dataru');
        //           } else if (Localizations.localeOf(context).languageCode ==
        //               'en') {
        //             collRef = FirebaseFirestore.instance.collection('dataen');
        //           }
        //           String targetTitle =
        //               widget.selectedKey; // Значение, которое вы ищете
        //           QuerySnapshot<Map<String, dynamic>> querySnapshot =
        //               await collRef.get();
        //           List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        //               querySnapshot.docs;
        //           for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        //               in docs) {
        //             Map<String, dynamic> autodata = doc.data();
        //             String autokey = doc.id; // Получение ключа документа
        //             // Проверка, соответствует ли поле title значению, которое вы ищете
        //             if (autodata['id'] == targetTitle) {
        //               keyforedit = autodata['id'];
        //             }
        //           }
        //           await Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (BuildContext context) => EditFirebasePage(
        //                 //editMydb: editMydb,
        //                 selectedKey: keyforedit,
        //               ),
        //             ),
        //           );
        //         },
        //         mini:
        //             true, // Установите mini: true для уменьшения размера кнопки
        //         shape: RoundedRectangleBorder(
        //           borderRadius:
        //               BorderRadius.circular(15), // Настройте форму кнопки
        //         ),
        //         child: const Icon(Icons.create),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(right: 0.0, bottom: 0.0),
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => HomePage(),
        //             ),
        //           );
        //           late CollectionReference<Map<String, dynamic>> collRef;
        //           if (Localizations.localeOf(context).languageCode == 'kk') {
        //             collRef = FirebaseFirestore.instance.collection('datakz');
        //           } else if (Localizations.localeOf(context).languageCode ==
        //               'ru') {
        //             collRef = FirebaseFirestore.instance.collection('dataru');
        //           } else if (Localizations.localeOf(context).languageCode ==
        //               'en') {
        //             collRef = FirebaseFirestore.instance.collection('dataen');
        //           }
        //           String targetTitle =
        //               widget.selectedKey; // Значение, которое вы ищете

        //           QuerySnapshot<Map<String, dynamic>> querySnapshot =
        //               await collRef.get();
        //           List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        //               querySnapshot.docs;
        //           for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        //               in docs) {
        //             Map<String, dynamic> autodata = doc.data();
        //             String autokey = doc.id; // Получение ключа документа
        //             // Проверка, соответствует ли поле title значению, которое вы ищете
        //             if (autodata['id'] == targetTitle) {
        //               await collRef.doc(autokey).delete();
        //               print("Document deleted: $autokey");
        //             }
        //           }
        //         },
        //         mini:
        //             true, // Установите mini: true для уменьшения размера кнопки
        //         shape: RoundedRectangleBorder(
        //           borderRadius:
        //               BorderRadius.circular(15), // Настройте форму кнопки
        //         ),
        //         child: const Icon(Icons.delete),
        //       ),
        //     ),
        //   ],
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        SizedBox(
          width: 10, // Устанавливаем отступ сверху
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: SizedBox(
            width: 230,
            child: FutureBuilder(
              builder: (context, snapshot) {
                return mySearchQR();
              },
              future: Future.delayed(const Duration(seconds: 1)),
            ),
          ),
        ),
        // IconButton(
        //   padding: const EdgeInsets.only(left: 0),
        //   onPressed: () {},
        //   icon: Icon(Icons.bookmark_add),
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: DropdownFlag(
            changedLanguage: (value) {
              setState(() {
                context.setLocale(Locale((value)));
              });
            },
          ),
        ),
      ],
      // leading: Builder(
      //   builder: (context) {
      //     return Padding(
      //       padding: const EdgeInsets.only(
      //           right: 20.0), // Устанавливаем отступ слева
      //       child: IconButton(
      //         icon: Icon(Icons.menu),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //       ),
      //     );
      //   },
      // ),
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

    print("discripWidgetsKz***${discripWidgetsKz}");
    print("discripWidgetsEn***${discripWidgetsEn}");
    print("discripWidgetsRu***${discripWidgetsRu}");
    print("discripWidgetsEmpt***${discripWidgetsEmpt}");
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
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 0,
                  top: 10,
                  right: 0,
                ),
                child: Text(
                  "description".tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 0,
                  top: 10,
                  right: 10,
                ),
                color: Colors.white,
                child: Text(
                  displayedText, // Make sure the value is not null
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class mySearchQR extends StatefulWidget {
  @override
  State<mySearchQR> createState() => _MySearchState();
}

class _MySearchState extends State<mySearchQR> {
  TextEditingController keywordTextObj = TextEditingController();

  @override
  void dispose() {
    keywordTextObj.dispose();
    super.dispose(); // Вызываем суперклассовый метод dispose
  }

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
          controller: keywordTextObj,
          onSubmitted: (value) {
            setState(() {
              keywordTextObj.text = value;
            });
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // setState(() {
                  //   keywordAsyncFunction(keyword.text);
                  // });
                  if (keywordTextObj != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          if (keywordTextObj.text.isNotEmpty) {
                            return takeSearchFirebasePage(
                                // resList: resList,
                                mykeyword: keywordTextObj.text,
                                takekeywordText: keywordTextObj);
                          } else {
                            return HomePage();
                          }
                        },
                      ),
                    );
                  }
                  _audioPlayer.stop();
                }),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                keywordTextObj.text = '';
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
      if (widget.selectedKey == datafirebasekz[i]['id'] &&
          !titleWidgetsArr.contains(titleWidgetsKz)) {
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

    print("titleWidgetsKz***${titleWidgetsKz}");
    print("titleWidgetsEn***${titleWidgetsEn}");
    print("titleWidgetsRu***${titleWidgetsRu}");
    print("titleWidgetsEmpt***${titleWidgetsEmpt}");
    print("titleWidgetsArr $titleWidgetsArr");
    print("titleWidgetsArr.length ${titleWidgetsArr.length}");

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
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        //decoration: BoxDecoration(color: Colors.green),
                        // padding: const EdgeInsets.only(left: 5),
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                //decoration: BoxDecoration(color: Colors.red),
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  bottom: 0,
                                  top: 0,
                                  right: 0,
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Выровнять текст влево
                                    children: [
                                      Text(
                                        titledisplayedText,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(color: Colors.amber),
                              padding: const EdgeInsets.only(
                                left: 50,
                                bottom: 15,
                                top: 0,
                                right: 0,
                              ),
                              // child: Row(
                              //   children: [
                              //     IconButton(
                              //       padding: const EdgeInsets.only(
                              //         left: 0,
                              //         bottom: 0,
                              //         top: 0,
                              //         right: 0,
                              //       ),
                              //       onPressed: () {},
                              //       icon: Icon(Icons.bookmark_add),
                              //     ),
                              //     IconButton(
                              //       icon: Icon(
                              //         Icons.share_outlined,
                              //         color: Colors.green,
                              //       ),
                              //       onPressed: () {
                              //         // Действие при нажатии на иконку "bookmark_add"
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //decoration: BoxDecoration(color: Colors.red),
                        padding: const EdgeInsets.only(
                          left: 0,
                          bottom: 5,
                          top: 5,
                          right: 0,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.star_border,
                            color: Colors.green,
                            size: 24,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.green,
                            size: 24,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.green,
                            size: 24,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.green,
                            size: 24,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.green,
                            size: 24,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

AudioPlayer _audioPlayer = AudioPlayer();

class MusicPlayerWidget extends StatefulWidget {
  String selectedKey;
  MusicPlayerWidget({
    required this.selectedKey,
  });

  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  List<String> audioWidgetsArr = [];
  String audioWidgetsKz = "";
  String audioWidgetsRu = "";
  String audioWidgetsEn = "";

  String audioPathKz = "";
  String audioPathRu = "";
  String audioPathEn = "";

  @override
  Future<List<String>> fetchKeysFirebaseAudio() async {
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
          "datafirebasekz[i]['audio']KZ from firebase ${datafirebasekz[i]['fileaudiopath']}");
      if (widget.selectedKey == datafirebasekz[i]['id']) {
        audioWidgetsKz = datafirebasekz[i]['fileaudiopath'];
        audioPathKz = datafirebasekz[i]['firebaseaudiopath'];
        audioWidgetsArr.add(audioWidgetsKz);
        audioWidgetsArr.add(audioPathKz);
        break;
      }
    }

    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokey = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseru[i]['audio']RU from firebase ${datafirebaseru[i]['fileaudiopath']}");
      if (widget.selectedKey == datafirebaseru[i]['id']) {
        audioWidgetsRu = datafirebaseru[i]['fileaudiopath'];
        audioPathRu = datafirebaseru[i]['firebaseaudiopath'];
        audioWidgetsArr.add(audioWidgetsRu);
        audioWidgetsArr.add(audioPathRu);
        break;
      }
      print('widget.selectedKey ${widget.selectedKey}');
    }

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokey = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseen[i]['audio']EN from firebase ${datafirebaseen[i]['fileaudiopath']}");
      if (widget.selectedKey == datafirebaseen[i]['id']) {
        audioWidgetsEn = datafirebaseen[i]['fileaudiopath'];
        audioPathEn = datafirebaseen[i]['firebaseaudiopath'];
        audioWidgetsArr.add(audioPathEn);
        break;
      }
    }

    print("audioWidgetsKz***${audioWidgetsKz}");
    print("audioWidgetsRu***${audioWidgetsRu}");
    print("audioWidgetsEn***${audioWidgetsEn}");
    print("audioPathKz***${audioPathKz}");
    print("audioPathRu***${audioPathRu}");
    print("audioPathEn***${audioPathEn}");
    print("audioWidgetsArr $audioWidgetsArr");
    print("audioWidgetsArr.length ${audioWidgetsArr.length}");

    return audioWidgetsArr;
  }

  // AudioPlayer _audioPlayer = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  Widget build(BuildContext context) {
    String audioDisplayed = "";
    String audioPath = "";

    Future downloadFile() async {
      try {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          final ref = FirebaseStorage.instance.ref().child(audioPath);
          final url = await ref.getDownloadURL();

          //final tempDir = await getTemporaryDirectory();
          final downloadDirectoryPath =
              '/storage/emulated/0/Download/${ref.name}';
          String downloadPath = "";
          final downloadsDirectory = await getExternalStorageDirectory();
          if (downloadsDirectory != null) {
            downloadPath = '${downloadsDirectory.path}/${ref.name}';
            // Теперь у вас есть путь к директории "Загрузки" на устройстве.
            // Можете использовать его для сохранения файлов.
          }

          await Dio().download(url, downloadPath);
          if (url.contains('.mp3')) {
            await SaverGallery.saveFile(
                file: downloadPath, name: ref.name, androidExistNotSave: true);
          }
          await File(downloadPath).copy(File(downloadDirectoryPath).path);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloaded ${ref.name}'),
            ),
          );
          print('Saving in the: $downloadPath');
          print('Saving in the: $downloadDirectoryPath');
        } else {
          print('Permission denied for storage');
        }
      } catch (e, stackTrace) {
        print('Error download: $e');
        print(stackTrace); // Вывод стека вызовов для отладки
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error download: $e'),
          ),
        );
      }
    }

    return FutureBuilder<List<String>>(
        // Pass the Future that will return data after executing fetchKeysFirebase()
        future: fetchKeysFirebaseAudio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting for data
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          // If data is loaded successfully, display it
          List<String> audioWidgetsArr = snapshot.data ?? [];
          print("***<=>audioWidgetsArr $audioWidgetsArr");

          print("***<=>audioWidgetsArr.length ${audioWidgetsArr.length}");

          print("***<=>widget.selectedKey ${widget.selectedKey}");

          String audioWidgets = "";

          // String audioWidgetsRus = "";
          // String audioWidgetsEng = "";

          //String audioDisplayed = "";
          String currentLanguagekz = 'kk';
          String currentLanguageru = 'ru';
          String currentLanguageen = 'en';

          List<String> uniqueAudioWidgetsArr = [];

          audioWidgetsArr.forEach((element) {
            if (!uniqueAudioWidgetsArr.contains(element)) {
              uniqueAudioWidgetsArr.add(element);
            }
            print("***<=>elementaudio $element");
          });

          audioWidgetsArr.clear();
          print("audioWidgetsArr.clear $audioWidgetsArr");

          uniqueAudioWidgetsArr.forEach((element) {
            print("***<=>uniqueelementaudio $element");
            if (element == audioWidgetsKz &&
                element == audioWidgetsRu &&
                element == audioWidgetsEn) {
              audioWidgets = audioWidgets + element;
            }
            print("***<=>audioWidgets $audioWidgets");

            if (element == audioPathKz &&
                element == audioPathRu &&
                element == audioPathEn) {
              audioPath = audioPath + element;
            }
            print("***<=>audioPath $audioPath");
          });

          if (Localizations.localeOf(context).languageCode ==
              currentLanguagekz) {
            // fetchKeysFirebase();
            _audioPlayer.pause();
            if (audioWidgets.isNotEmpty) {
              audioDisplayed = audioWidgets;
            }
          }
          if (Localizations.localeOf(context).languageCode ==
              currentLanguageru) {
            _audioPlayer.pause();
            // fetchKeysFirebase();
            if (audioWidgets.isNotEmpty) {
              audioDisplayed = audioWidgets;
            }
          }
          if (Localizations.localeOf(context).languageCode ==
              currentLanguageen) {
            _audioPlayer.pause();
            // fetchKeysFirebase;
            if (audioWidgets.isNotEmpty) {
              audioDisplayed = audioWidgets;
            }
          }

          print("audioWidgets $audioWidgets");
          // print("audioWidgetsRus $audioWidgetsRus");
          // print("audioWidgetsEng $audioWidgetsEng");
          print('audioDisplayed $audioDisplayed');

          _audioPlayer.setUrl(audioDisplayed);

          uniqueAudioWidgetsArr.clear();
          print("uniqueAudioWidgetsArr.clear $uniqueAudioWidgetsArr");
          // @override
          // void initState() {
          //   _audioPlayer.setAudioSource(
          //     AudioSource.uri(
          //       Uri.parse(audioDisplayed),
          //     ),
          //   );
          //   super.initState();
          // }

          return WillPopScope(
            onWillPop: () async {
              if (_audioPlayer.playing) {
                _audioPlayer.stop(); // Остановите аудиоплеер
              }
              return true; // Разрешить закрытие экрана
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.green, // Цвет верхней границы
                    width: 1.0, // Ширина верхней границы
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.green, // Цвет верхней границы
                          width: 1.0, // Ширина верхней границы
                        ),
                      ),
                    ),
                    child: StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SeekBar(
                          duration: positionData?.duration ?? Duration.zero,
                          position: positionData?.position ?? Duration.zero,
                          bufferedPosition:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onChangedEnd: _audioPlayer.seek,
                        );
                      },
                    ),
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.green, // Цвет верхней границы
                    //     width: 1.0, // Ширина верхней границы
                    //   ),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.red,
                          // ),
                          child: StreamBuilder<PlayerState>(
                            stream: _audioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final proccessingState =
                                  playerState?.processingState;
                              final playing = playerState?.playing;

                              if (proccessingState == ProcessingState.loading ||
                                  proccessingState ==
                                      ProcessingState.buffering) {
                                return Container(
                                  margin: EdgeInsets.all(8.0),
                                  width: 25,
                                  height: 25,
                                );
                              } else if (playing != true) {
                                return IconButton(
                                    onPressed: _audioPlayer.play,
                                    icon: const Icon(Icons.play_arrow));
                              } else if (proccessingState !=
                                  ProcessingState.completed) {
                                return IconButton(
                                  onPressed: _audioPlayer.pause,
                                  iconSize: 25,
                                  icon: const Icon(Icons.pause),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () =>
                                      _audioPlayer.seek(Duration.zero),
                                  iconSize: 25,
                                  icon: const Icon(Icons.replay),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.red,
                          // ),
                          width: 90,
                          height: 48,
                          child: ListTile(
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.black,
                              ),
                              onPressed: () => downloadFile(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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

  // @override
  // void initState() {
  //   super.initState();
  //   // Вызываем fetchKeysFirebase() только один раз при инициализации виджета
  //   fetchKeysFirebasePhoto();
  // }
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
          "datafirebasekz[i]['filephotopath']KZ from firebase ${datafirebasekz[i]['filephotopath']}");
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
          "datafirebaseru[i]['filephotopath']RU from firebase ${datafirebaseru[i]['filephotopath']}");
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
          "datafirebasekz[i]['filephotopath']EN from firebase ${datafirebaseen[i]['filephotopath']}");
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

    print("photoWidgetsKz***${photoWidgetsKz}");
    print("photoWidgetsEn***${photoWidgetsEn}");
    print("photoWidgetsRu***${photoWidgetsRu}");
    print("photoWidgetsEmpt***${photoWidgetsEmpt}");
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
        print("***<=>photoWidgetsArr $photoWidgetsArr");

        print("***<=>photoWidgetsArr.length ${photoWidgetsArr.length}");

        print("***<=>widget.selectedKey ${widget.selectedKey}");

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
          }
          if (photoWidgetsRu == element) {
            photoWidgetsRus = photoWidgetsRus + element;
          }
          if (photoWidgetsEn == element) {
            photoWidgetsEng = photoWidgetsEng + element;
          }
          photoWidgetsEmpty = photoWidgetsEmpty + element;

          print("***<=>element $element");
        });

        photoWidgetsArr.clear();

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
        return Padding(
          padding: EdgeInsets.only(top: 0),
          child: Container(
            height: 160,
            width: 340,
            child: Card(
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
              elevation: 5,
              // child: Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(0),
              //     image: DecorationImage(
              //       image: AssetImage('lib/assets/images/mavzoley_yasavi.jpg'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              child: Image.network(
                photoDisplayed,
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
                _audioPlayer.stop();
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
              _audioPlayer.stop();
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
              _audioPlayer.stop();
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
