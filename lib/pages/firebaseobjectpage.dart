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
import 'package:path/path.dart';

class ObjectFirebasePage extends StatefulWidget {
  final String selectedKey; // Добавьте параметр для выбранного ключа
  ObjectFirebasePage({
    required this.selectedKey,
  });

  @override
  State<ObjectFirebasePage> createState() => _ObjectFirebasePageState();
}

class _ObjectFirebasePageState extends State<ObjectFirebasePage> {
  String currentSelectedKey = ''; // Инициализируйте переменную пустым значением

  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);
  @override
  Widget build(BuildContext context) {
    late String currentKz = 'kk';
    late String currentRu = 'ru';
    late String currentEn = 'en';

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
                        selectedKey: widget.selectedKey,
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

  // @override
  // void initState() {
  //   super.initState();
  //   fetchKeysFirebase(); // Загрузите ключи из Firebase
  // }
  List<String> discripWidgetsArr = [];
  String discripWidgetsKz = "";
  String discripWidgetsRu = "";
  String discripWidgetsEn = "";
  String discripWidgetsEmpt = "";
  bool dataLoaded = false; // Добавили флаг для отслеживания загрузки данных

  // void initState() {
  //   super.initState();
  //   // Вызываем fetchKeysFirebaseOver() только при первой загрузке виджета
  //   fetchKeysFirebaseOver().then((_) {
  //     // После завершения загрузки данных устанавливаем флаг dataLoaded в true
  //     setState(() {
  //       dataLoaded = true;
  //     });
  //   });
  //   fetchData(); // Вызываем асинхронную функцию при инициализации
  // }
  @override
  void initState() {
    super.initState();
    fetchData(); // Вызываем асинхронную функцию при инициализации
  }

  Future<void> fetchData() async {
    discripWidgetsArr = await fetchKeysFirebaseOver();
    setState(() {
      dataLoaded = true;
    });
  }

  // @override
  //  void initState() {
  //   super.initState();
  //   // Вызываем fetchKeysFirebaseOver() только при первой загрузке виджета
  //   fetchKeysFirebaseOver();
  // }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Вызываем fetchKeysFirebaseOver при изменении зависимостей (например, при изменении языка)
  //   fetchKeysFirebaseOver();
  // }
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

    late String autokeykz;
    late String autokeyru;
    late String autokeyen;

    late Map<String, dynamic> autodata;
    for (int i = 0; i < datafirebasekz.length; i++) {
      autokeykz = datafirebasekz[i].id;
      autodata = datafirebasekz[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']KZ from firebase ${datafirebasekz[i]['title']}");
      if (widget.selectedKey == datafirebasekz[i]['title'] &&
          !discripWidgetsArr.contains(discripWidgetsKz)) {
        discripWidgetsKz = datafirebasekz[i]['description'];
        discripWidgetsArr.add(discripWidgetsKz);
        break;
      }
      // else if (autokeykz == autokeykz &&
      //     !discripWidgetsArr.contains(autokeykz) &&
      //     const Locale('kk').languageCode == 'kk' &&
      //     widget.selectedKey == datafirebasekz[i]['title']) {
      //   discripWidgetsKz = datafirebasekz[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsKz);
      //   break;
      // }
      // else if (autokeykz == autokeykz &&
      //     !discripWidgetsArr.contains(autokeykz) &&
      //     const Locale('kk').languageCode == 'kk') {
      //   discripWidgetsKz = datafirebasekz[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsKz);
      //   break;
      // }
    }
    print("autokeykz $autokeykz");

    for (int i = 0; i < datafirebaseru.length; i++) {
      autokeyru = datafirebaseru[i].id;
      autodata = datafirebaseru[i].data() as Map<String, dynamic>;
      print(
          "datafirebaseru[i]['title']RU from firebase ${datafirebaseru[i]['title']}");
      if (widget.selectedKey == datafirebaseru[i]['title'] &&
          !discripWidgetsArr.contains(discripWidgetsRu)) {
        discripWidgetsRu = datafirebaseru[i]['description'];
        print(
            "datafirebaseru[i]['description'] $datafirebaseru[i]['description']");
        print("discripWidgetsRu $discripWidgetsRu");
        discripWidgetsArr.add(discripWidgetsRu);
        break;
      }
      // else if (autokeyru == autokeyru &&
      //     !discripWidgetsArr.contains(autokeyru) &&
      //     const Locale('ru').languageCode == 'ru' &&
      //     widget.selectedKey == datafirebaseru[i]['title']) {
      //   discripWidgetsRu = datafirebaseru[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsRu);
      //   break;
      // }
      // else if (autokeyru == autokeyru &&
      //     !discripWidgetsArr.contains(autokeyru) &&
      //     const Locale('ru').languageCode == 'ru') {
      //   discripWidgetsRu = datafirebasekz[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsRu);
      //   break;
      // }
    }
    print("autokeyru $autokeyru");

    print("widget.selectedKey from firebase ${widget.selectedKey}");

    for (int i = 0; i < datafirebaseen.length; i++) {
      autokeyen = datafirebaseen[i].id;
      autodata = datafirebaseen[i].data() as Map<String, dynamic>;
      print(
          "datafirebasekz[i]['title']EN from firebase ${datafirebaseen[i]['title']}");
      print("111widget.selectedKey111 ${widget.selectedKey}}");
      if (widget.selectedKey == datafirebaseen[i]['title'] &&
          !discripWidgetsArr.contains(discripWidgetsEn)) {
        discripWidgetsEn = datafirebaseen[i]['description'];
        print("111discripWidgetsEn111 $discripWidgetsEn");
        discripWidgetsArr.add(discripWidgetsEn);
        break;
      }

      // else if (autokeyen == autokeyen &&
      //     !discripWidgetsArr.contains(autokeyen) &&
      //     const Locale('en').languageCode == 'en' &&
      //     widget.selectedKey == datafirebaseen[i]['title']) {
      //   discripWidgetsEn = datafirebaseen[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsEn);
      //   break;
      // } else if (autokeyen == autokeyen &&
      //     !discripWidgetsArr.contains(autokeyen) &&
      //     const Locale('en').languageCode == 'en') {
      //   discripWidgetsEn = datafirebasekz[i]['description'];
      //   discripWidgetsArr.add(discripWidgetsEn);
      //   break;
      // }
      print("widget.selectedKeyEN ${widget.selectedKey}");
    }
    //print("discripWidgetsEn from firebase $discripWidgetsEn");
    print("autokeyen $autokeyen");

    if (discripWidgetsKz.isEmpty &&
        discripWidgetsRu.isEmpty &&
        discripWidgetsEn.isEmpty &&
        autokeykz == autokeykz &&
        autokeyru == autokeyru &&
        autokeyen == autokeyen) {
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
    if (!dataLoaded) {
      // Если данные ещё не загружены, отображаем индикатор загрузки
      return CircularProgressIndicator();
    }

    // If data is loaded successfully, display it
    print("*******************<=>discripWidgetsArr $discripWidgetsArr");

    print(
        "*******************<=>discripWidgetsArr.length ${discripWidgetsArr.length}");

    print("*******************<=>widget.selectedKey ${widget.selectedKey}");

    String discripWidgetsKaz = "";
    String discripWidgetsRus = "";
    String discripWidgetsEng = "";
    String discripWidgetsEmpty = "";

    late List<String> uniquediscripWidgetsArr = [];

    discripWidgetsArr.forEach((element) {
      if (!discripWidgetsArr.contains(discripWidgetsKz) ||
          !discripWidgetsArr.contains(discripWidgetsRu) ||
          !discripWidgetsArr.contains(discripWidgetsEn)) {
        uniquediscripWidgetsArr.add(element);
      }
    });

    // uniquediscripWidgetsArr.forEach((element) {
    //   if (discripWidgetsKz == element) {
    //     discripWidgetsKaz = discripWidgetsKaz + element;
    //   } else if (discripWidgetsRu == element) {
    //     discripWidgetsRus = discripWidgetsRus + element;
    //   } else if (discripWidgetsEn == element) {
    //     discripWidgetsEng = discripWidgetsEng + element;
    //   } else {
    //     discripWidgetsEmpty = discripWidgetsEmpty + element;
    //   }
    //   print("*******************<=>element $element");
    // });

    //discripWidgetsArr.clear();

    // String currentLanguagekz = 'kk';
    // String currentLanguageru = 'ru';
    // String currentLanguageen = 'en';
    String displayedText = "";
    String currentLanguageCode = Localizations.localeOf(context).languageCode;

    for (String description in uniquediscripWidgetsArr) {
      if (description.isNotEmpty &&
          (currentLanguageCode == 'kk' && discripWidgetsKz.isNotEmpty ||
              currentLanguageCode == 'ru' && discripWidgetsRu.isNotEmpty ||
              currentLanguageCode == 'en' && discripWidgetsEn.isNotEmpty)) {
        displayedText = description;
        break;
      }
    }
    // if (discripWidgetsKaz.isNotEmpty &&
    //     Localizations.localeOf(context).languageCode == 'kk') {
    //   displayedText = discripWidgetsKaz;
    // } else if (discripWidgetsRus.isNotEmpty &&
    //     Localizations.localeOf(context).languageCode == 'ru') {
    //   displayedText = discripWidgetsRus;
    // } else if (discripWidgetsEng.isNotEmpty &&
    //     Localizations.localeOf(context).languageCode == 'en') {
    //   displayedText = discripWidgetsEng;
    // } else {
    //   displayedText = discripWidgetsEmpty;
    // }

    // if (discripWidgetsKaz.isNotEmpty) {
    //   displayedText = discripWidgetsKaz;
    // } else if (discripWidgetsRus.isNotEmpty) {
    //   displayedText = discripWidgetsRus;
    // } else if (discripWidgetsEng.isNotEmpty) {
    //   displayedText = discripWidgetsEng;
    // } else {
    //   displayedText = discripWidgetsEmpty;
    // }
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
  }

  // return FutureBuilder<List<String>>(
  //   // Pass the Future that will return data after executing fetchKeysFirebase()
  //   future: fetchKeysFirebaseOver(),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return CircularProgressIndicator(); // Show a loading indicator while waiting for data
  //     }

  //     if (snapshot.hasError) {
  //       return Text("Error: ${snapshot.error}");
  //     }

  //     // If data is loaded successfully, display it
  //     final List<String> discripWidgetsArr = snapshot.data ?? [];
  //     print("*******************<=>discripWidgetsArr $discripWidgetsArr");

  //     print(
  //         "*******************<=>discripWidgetsArr.length ${discripWidgetsArr.length}");

  //     print("*******************<=>widget.selectedKey ${widget.selectedKey}");

  //     String discripWidgetsKaz = "";
  //     String discripWidgetsRus = "";
  //     String discripWidgetsEng = "";
  //     String discripWidgetsEmpty = "";

  //     late List<String> uniquediscripWidgetsArr = [];

  //     discripWidgetsArr.forEach((element) {
  //       if (!discripWidgetsArr.contains(discripWidgetsKaz) ||
  //           !discripWidgetsArr.contains(discripWidgetsRus) ||
  //           !discripWidgetsArr.contains(discripWidgetsEng)) {
  //         uniquediscripWidgetsArr.add(element);
  //       }
  //     });

  //     uniquediscripWidgetsArr.forEach((element) {
  //       if (discripWidgetsKz == element) {
  //         discripWidgetsKaz = discripWidgetsKaz + element;
  //       } else if (discripWidgetsRu == element) {
  //         discripWidgetsRus = discripWidgetsRus + element;
  //       } else if (discripWidgetsEn == element) {
  //         discripWidgetsEng = discripWidgetsEng + element;
  //       } else {
  //         discripWidgetsEmpty = discripWidgetsEmpty + element;
  //       }
  //       print("*******************<=>element $element");
  //     });

  //     discripWidgetsArr.clear();

  //     // String currentLanguagekz = 'kk';
  //     // String currentLanguageru = 'ru';
  //     // String currentLanguageen = 'en';
  //     String displayedText = "";

  //     if (discripWidgetsKaz.isNotEmpty &&
  //         Localizations.localeOf(context).languageCode == 'kk') {
  //       displayedText = discripWidgetsKaz;
  //     } else if (discripWidgetsRus.isNotEmpty &&
  //         Localizations.localeOf(context).languageCode == 'ru') {
  //       displayedText = discripWidgetsRus;
  //     } else if (discripWidgetsEng.isNotEmpty &&
  //         Localizations.localeOf(context).languageCode == 'en') {
  //       displayedText = discripWidgetsEng;
  //     } else {
  //       displayedText = discripWidgetsEmpty;
  //     }

  //     // if (discripWidgetsKaz.isNotEmpty) {
  //     //   displayedText = discripWidgetsKaz;
  //     // } else if (discripWidgetsRus.isNotEmpty) {
  //     //   displayedText = discripWidgetsRus;
  //     // } else if (discripWidgetsEng.isNotEmpty) {
  //     //   displayedText = discripWidgetsEng;
  //     // } else {
  //     //   displayedText = discripWidgetsEmpty;
  //     // }
  //     print("displayedText  $displayedText");
  //     print("discripWidgetsArr clear $discripWidgetsArr");
  //     print("discripWidgetsKaz $discripWidgetsKaz");
  //     print("discripWidgetsRus $discripWidgetsRus");
  //     print("discripWidgetsEng $discripWidgetsEng");
  //     print("discripWidgetsEmpty $discripWidgetsEmpty");

  //     return Container(
  //       color: Colors.amber,
  //       child: Text(
  //         displayedText, // Make sure the value is not null
  //         style: whiteTextStyle,
  //         textAlign: TextAlign.justify,
  //       ),
  //     );
  //   },
  // );
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
      if (widget.selectedKey == datafirebasekz[i]['title'] &&
          !titleWidgetsArr.contains(titleWidgetsKz)) {
        titleWidgetsKz = datafirebasekz[i]['title'];
        titleWidgetsArr.add(titleWidgetsKz);
        break;
      } else if (autokey == autokey && !titleWidgetsArr.contains(autokey)) {
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
      if (widget.selectedKey == datafirebaseru[i]['title'] &&
          !titleWidgetsArr.contains(titleWidgetsRu)) {
        titleWidgetsRu = datafirebaseru[i]['title'];
        titleWidgetsArr.add(titleWidgetsRu);
        break;
      } else if (autokey == autokey && !titleWidgetsArr.contains(autokey)) {
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
      if (widget.selectedKey == datafirebaseen[i]['title'] &&
          !titleWidgetsArr.contains(titleWidgetsEn)) {
        titleWidgetsEn = datafirebaseen[i]['title'];
        titleWidgetsArr.add(titleWidgetsEn);
        break;
      } else if (autokey == autokey && !titleWidgetsArr.contains(autokey)) {
        titleWidgetsEn = datafirebaseen[i]['title'];
        titleWidgetsArr.add(titleWidgetsEn);
        break;
      }
    }
    //print("discripWidgetsEn from firebase $discripWidgetsEn");

    if (titleWidgetsKz.isEmpty &&
        titleWidgetsRu.isEmpty &&
        titleWidgetsEn.isEmpty &&
        autokey == autokey) {
      titleWidgetsEmpt = autodata['title'];
      titleWidgetsArr.add(titleWidgetsEmpt);
    }
    // print("discripWidgetsEmpt from firebase $discripWidgetsEmpt");

    // print("discripWidgetsKz $discripWidgetsKz");
    // print("discripWidgetsRu $discripWidgetsRu");
    // print("discripWidgetsEn $discripWidgetsEn");
    // print("discripWidgetsEmpt $discripWidgetsEmpt");
    //print("********************\n${discripWidgetsKz.toString()}");

    print("titleWidgetsKz***************${titleWidgetsKz}");
    print("titleWidgetsEn***************${titleWidgetsEn}");
    print("titleWidgetsRu***************${titleWidgetsRu}");
    print("titleWidgetsEmpt***************${titleWidgetsEmpt}");
    //print("********************\n${discripWidgetsEn.toString()}");
    print("titleWidgetsArr $titleWidgetsArr");
    print("titleWidgetsArr.length ${titleWidgetsArr.length}");

    // setState(() {
    //   discripWidgetsArr;
    // });

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
        print("*******************<=>titleWidgetsArr $titleWidgetsArr");

        print(
            "*******************<=>titleWidgetsArr.length ${titleWidgetsArr.length}");

        print("*******************<=>widget.selectedKey ${widget.selectedKey}");

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
          print("*******************<=>element $element");
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

        // if (titleWidgetsKaz.isNotEmpty) {
        //   titledisplayedText = titleWidgetsKaz;
        // } else if (titleWidgetsRus.isNotEmpty) {
        //   titledisplayedText = titleWidgetsRus;
        // } else if (titleWidgetsEng.isNotEmpty) {
        //   titledisplayedText = titleWidgetsEng;
        // } else {
        //   titledisplayedText = titleWidgetsEmpty;
        // }

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
          "datafirebasekz[i]['title']KZ from firebase ${datafirebasekz[i]['title']}");
      if (widget.selectedKey == datafirebasekz[i]['title'] &&
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
      if (widget.selectedKey == datafirebaseru[i]['title'] &&
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
      if (widget.selectedKey == datafirebaseen[i]['title'] &&
          !photoWidgetsArr.contains(photoWidgetsEn)) {
        photoWidgetsEn = datafirebaseen[i]['filephotopath'];
        photoWidgetsArr.add(photoWidgetsEn);
        break;
      }
    }
    //print("discripWidgetsEn from firebase $discripWidgetsEn");

    if (photoWidgetsKz.isEmpty &&
        photoWidgetsRu.isEmpty &&
        photoWidgetsEn.isEmpty &&
        autokey == autokey) {
      photoWidgetsEmpt = autodata['filephotopath'];
      photoWidgetsArr.add(photoWidgetsEmpt);
    }

    // print("discripWidgetsEmpt from firebase $discripWidgetsEmpt");
    // print("discripWidgetsKz $discripWidgetsKz");
    // print("discripWidgetsRu $discripWidgetsRu");
    // print("discripWidgetsEn $discripWidgetsEn");
    // print("discripWidgetsEmpt $discripWidgetsEmpt");
    //print("********************\n${discripWidgetsKz.toString()}");
    print("photoWidgetsKz***************${photoWidgetsKz}");
    print("photoWidgetsEn***************${photoWidgetsEn}");
    print("photoWidgetsRu***************${photoWidgetsRu}");
    print("photoWidgetsEmpt***************${photoWidgetsEmpt}");
    //print("********************\n${discripWidgetsEn.toString()}");
    print("photoWidgetsArr $photoWidgetsArr");
    print("photoWidgetsArr.length ${photoWidgetsArr.length}");

    // setState(() {
    //   discripWidgetsArr;
    // });

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

        //   if (photoWidgetsKaz.isNotEmpty) {
        //   photoDisplayed = photoWidgetsKaz;
        // } else if (photoWidgetsRus.isNotEmpty) {
        //   photoDisplayed = photoWidgetsRus;
        // } else if (photoWidgetsEng.isNotEmpty) {
        //   photoDisplayed = photoWidgetsEng;
        // } else {
        //   photoDisplayed = photoWidgetsEmpty;
        // }

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
                borderRadius: BorderRadius.circular(30),
              ),
              //child: Text('No image'),
              child: Image.file(
                File(photoDisplayed),
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
