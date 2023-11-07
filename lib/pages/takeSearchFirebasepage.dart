import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:flutter/services.dart';

class takeSearchFirebasePage extends StatefulWidget {
  final String mykeyword;
  TextEditingController takekeywordText;

  takeSearchFirebasePage(
      {required this.mykeyword, required this.takekeywordText});

  @override
  State<takeSearchFirebasePage> createState() => _ApptakeSearchPage();
}

class _ApptakeSearchPage extends State<takeSearchFirebasePage> {
  int _backPressCount = 0;
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  List<dynamic> onResultListChanged = [];

  void handleResultListChanged(List<dynamic> resultList) {
    setState(() {
      onResultListChanged = resultList;
    });
  }

  //String imageUrl = 'lib/assets/images/backgroundImages.jpg';
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
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Set your preferred height here
          child: MyAppBar(
            onResultListChanged: handleResultListChanged,
            mykeywordpage: widget.mykeyword,
            takekeywordTextpage: widget.takekeywordText,
          ), // Use your custom app bar
        ),
        body: SafeArea(
          child: DefaultTextStyle.merge(
            style: whiteTexstStyle,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  // Container(
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage(imageUrl),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //   ),
                  // ),
                  // AppBar(
                  //   elevation: 0,
                  //   backgroundColor: Color.fromARGB(255, 83, 112, 85),
                  //   title: Text(
                  //     'mytitlepage'.tr(),
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600,
                  //       color: Color.fromARGB(255, 184, 182, 156),
                  //     ),
                  //   ),
                  //   actions: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(right: 20),
                  //       child: DropdownFlag(
                  //         changedLanguage: (value) {
                  //           setState(() {
                  //             context.setLocale(Locale((value)));
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height - 126,
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: MyTakePage(
                      resultListHome: onResultListChanged,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: MenuTile(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  final ValueChanged<List<dynamic>> onResultListChanged;
  String mykeywordpage;
  TextEditingController takekeywordTextpage;

  MyAppBar(
      {required this.mykeywordpage,
      required this.takekeywordTextpage,
      required this.onResultListChanged,
      Key? key})
      : super(key: key);

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
                return FirebaseSearch(
                  onResultListChanged: widget.onResultListChanged,
                  mykeywordpagenow: widget.mykeywordpage,
                  keywordText: widget.takekeywordTextpage,
                );
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

class MyTakePage extends StatefulWidget {
  final List<dynamic> resultListHome;

  MyTakePage({required this.resultListHome, Key? key}) : super(key: key);
  @override
  MyTakePageState createState() => MyTakePageState();
}

class MyTakePageState extends State<MyTakePage> {
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final colorTextStyle = TextStyle(
      color: Color.fromARGB(255, 78, 82, 26),
      fontSize: 25,
    ); // Обновленный размер текста
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height +
                      26000, // appBarHeight - это высота вашего AppBar
                ),
                child: Column(
                  children: [
                    streamBuildHome(resultList: widget.resultListHome),
                  ],
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: Stack(
        //   children: [
        //     Positioned(
        //       right: 0,
        //       bottom: 0,
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //           await Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => CreateHistoryPost(),
        //             ),
        //           );
        //         },
        //         child: const Icon(Icons.create),
        //       ),
        //     ),
        //     Positioned(
        //       left: 20,
        //       bottom: 0,
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //           var collRefkz = FirebaseFirestore.instance.collection('datakz');
        //           var collRefru = FirebaseFirestore.instance.collection('dataru');
        //           var collRefen = FirebaseFirestore.instance.collection('dataen');

        //           QuerySnapshot querySnapshotkz = await collRefkz.get();
        //           QuerySnapshot querySnapshotru = await collRefru.get();
        //           QuerySnapshot querySnapshoten = await collRefen.get();

        //           List<QueryDocumentSnapshot> docskz = querySnapshotkz.docs;
        //           List<QueryDocumentSnapshot> docsru = querySnapshotru.docs;
        //           List<QueryDocumentSnapshot> docsen = querySnapshoten.docs;

        //           List<String> autokey = [];
        //           for (QueryDocumentSnapshot doc in docskz) {
        //             autokey.add(doc.id);
        //           }
        //           for (QueryDocumentSnapshot doc in docsru) {
        //             autokey.add(doc.id);
        //           }
        //           for (QueryDocumentSnapshot doc in docsen) {
        //             autokey.add(doc.id);
        //           }

        //           autokey.forEach((element) {
        //             collRefkz.doc(element).delete();
        //           });
        //           autokey.forEach((element) {
        //             collRefru.doc(element).delete();
        //           });
        //           autokey.forEach((element) {
        //             collRefen.doc(element).delete();
        //           });
        //         },
        //         child: const Icon(Icons.delete),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class FirebaseSearch extends StatefulWidget {
  final ValueChanged<List<dynamic>>
      onResultListChanged; // Изменили тип на ValueChanged

  String mykeywordpagenow;
  TextEditingController keywordText; // Добавьте это поле
  FirebaseSearch(
      {required this.mykeywordpagenow,
      required this.keywordText,
      required this.onResultListChanged,
      Key? key})
      : super(key: key);

  // const FirebaseSearch({Key? key}) : super(key: key);
  @override
  FirebaseSearchWidget createState() => FirebaseSearchWidget();
}

class FirebaseSearchWidget extends State<FirebaseSearch>
    with AutomaticKeepAliveClientMixin {
  TextEditingController controlkey = TextEditingController();

  List allResults = [];
  List resultList = [];

  @override
  void initState() {
    // getClientStream();
    widget.keywordText.addListener(_onSearchChanged);
    super.initState();
    // mapdata = mapOver.mapdatas;
  }

  _onSearchChanged() {
    print(controlkey.text);
    searchResultList();
  }

  searchResultList() {
    var showRes = [];

    if (controlkey.text != "" || widget.mykeywordpagenow != "") {
      for (var keySnap in allResults) {
        var id = keySnap['id'].toString().toLowerCase();
        var title = keySnap['title'].toString().toLowerCase();
        var description = keySnap['description'].toString().toLowerCase();
        if (id.contains(widget.keywordText.text.toLowerCase()) ||
            title.contains(widget.keywordText.text.toLowerCase()) ||
            description.contains(widget.keywordText.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
    } else {
      showRes = List.from(allResults);
    }

    // if (widget.mykeywordpagenow != "") {
    //   var keywords = widget.mykeywordpagenow.toLowerCase().split(" ");
    //   for (var keySnap in allResults) {
    //     var id = keySnap['id'].toString().toLowerCase();
    //     var title = keySnap['title'].toString().toLowerCase();
    //     var description = keySnap['description'].toString().toLowerCase();
    //     if (keywords.length == 1) {
    //       print('keywords.length ${keywords.length}');
    //       if (id.contains(widget.keywordText.text.toLowerCase()) ||
    //           title.contains(widget.keywordText.text.toLowerCase()) ||
    //           description.contains(widget.keywordText.text.toLowerCase())) {
    //         showRes.add(keySnap);
    //       }
    //     }

    // else if (keywords.length > 1) {
    //   print('keywords.length ${keywords.length}');
    //   bool found = false;
    //   for (var kw in keywords) {
    //     if (id.contains(kw) ||
    //         title.contains(kw) ||
    //         description.contains(kw)) {
    //       print("kw $kw");
    //       print("description $description");
    //       found = true;
    //       break;
    //     }
    //   }
    //   if (found) {
    //     showRes.add(keySnap);
    //   }
    // }

    showRes.forEach((element) {
      print("showReselement $element");
    });

    setState(() {
      resultList = showRes;
    });

    widget.onResultListChanged(resultList);
  }

  getClientStream() async {
    late QuerySnapshot<Map<String, dynamic>> datalingua;
    if (Localizations.localeOf(context).languageCode == 'kk') {
      datalingua = await FirebaseFirestore.instance
          .collection('datakz')
          .orderBy('id')
          .get();
    } else if (Localizations.localeOf(context).languageCode == 'ru') {
      datalingua = await FirebaseFirestore.instance
          .collection('dataru')
          .orderBy('id')
          .get();
    } else if (Localizations.localeOf(context).languageCode == 'en') {
      datalingua = await FirebaseFirestore.instance
          .collection('dataen')
          .orderBy('id')
          .get();
    }
    setState(() {
      allResults = datalingua.docs;
      searchResultList();
    });
  }

  @override
  void dispose() {
    widget.keywordText.removeListener(_onSearchChanged);
    widget.keywordText.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: TextField(
              controller: widget.keywordText,
              onSubmitted: (value) {
                setState(() {
                  // ignore: unrelated_type_equality_checks
                  widget.keywordText.text = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (widget.keywordText.text == '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                    setState(() {
                      getClientStream();
                    });
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.keywordText.text = '';
                  },
                ),
                hintText: 'searchword'.tr(),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        // Mausoleum(),
        // SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       maxHeight: MediaQuery.of(context).size.height -
        //           228, // appBarHeight - это высота вашего AppBar
        //     ),
        //     child: ListView(
        //       children: [
        //         streamBuild(resultList: resultList),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class streamBuild extends StatelessWidget {
  List<dynamic> resultList = [];

  streamBuild({
    required this.resultList,
  });

  @override
  final colorTextStyle = TextStyle(color: Colors.white, fontSize: 24);

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
          return Container(
            alignment: Alignment.center,
            child: const Text(
              'loading...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No Data');
        }
        final keysfirebase = snapshot.data?.docs.toList();

        if (resultList != "") {
          print('resultList from firebase ${resultList.asMap()}');
          return Column(
            children: resultList.map((data) {
              final doc = data.data() as Map<String, dynamic>;
              print("doc['id'] from firebase ${doc['id']}");
              return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Hero(
                    tag: 'id_${doc['id']}',
                    child: ElevatedButton(
                      onPressed: () {
                        if (doc == '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectFirebasePage(
                              selectedKey: doc['id'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        doc['title'],
                        style: colorTextStyle,
                      ),
                    ),
                  ));
            }).toList(),
          );
        } else {
          return Column(
            children: keysfirebase!.map((data) {
              final doc = data.data() as Map<String, dynamic>;
              return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Hero(
                    tag: 'id_${doc['id']}',
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectFirebasePage(
                              selectedKey: doc['id'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        doc['title'],
                        style: colorTextStyle,
                      ),
                    ),
                  ));
            }).toList(),
          );
        }
      },
    );
  }
}

class streamBuildHome extends StatelessWidget {
  List<dynamic> resultList;

  streamBuildHome({
    required this.resultList,
  });

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
    return WillPopScope(
      onWillPop: () async {
        // Выход из приложения при нажатии кнопки "назад"
        SystemNavigator.pop();
        return true; // Возвращаем true, чтобы разрешить выход из приложения
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: datastream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: const Text(
                'loading...',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data');
          }

          if (resultList != "") {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.greenAccent), // Устанавливаем красную границу
              ),
              child: Column(
                children: resultList.map((data) {
                  final doc = data.data() as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green), // Устанавливаем красную границу
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            top: 0,
                            bottom: 0,
                            right: 0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Colors.red,
                                //   ),
                                // ),
                                child: Image.network(
                                  doc['filephotopath'],
                                  width: 150,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                // Используем Expanded для текста и кнопки
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                  ),
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(
                                  //     color: Colors.red,
                                  //   ),
                                  // ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // Выравнивание текста по левому краю
                                    children: [
                                      Text(
                                        doc['title'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                        //overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 43,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ObjectFirebasePage(
                                                selectedKey: doc['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                        ),
                                        child: Container(
                                          width: double
                                              .infinity, // Разрешаем кнопке занимать всю ширину
                                          alignment: Alignment
                                              .topCenter, // Выравнивание текста по центру
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal:
                                                  0), // Отступы для текста кнопки
                                          child: Text(
                                            "details".tr(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  bottom: 10,
                                  top: 0,
                                  right: 10,
                                ),
                                height: 25,
                                width: 25,
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //       color: Colors
                                //           .red), // Устанавливаем красную границу
                                // ),
                                // child: IconButton(
                                //   padding: const EdgeInsets.only(
                                //     left: 0,
                                //     bottom: 10,
                                //     top: 0,
                                //     right: 10,
                                //   ),
                                //   onPressed: () {},
                                //   icon: Icon(Icons.bookmark_add),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(), // Convert the mapped items to a list
              ),
            );
          }
          return Container();
        },
      ),
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
          _buildButtonMap("mymap".tr(), Icons.map, Colors.black),
        ],
      );

  Widget _buildButtonMap(
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
                context,
                MaterialPageRoute(
                  builder: (context) => MapControlsPage(
                    id: "1",
                    selectedX: 43.29785383147346,
                    selectedY: 68.27119119202341,
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
                fontWeight: FontWeight.w300,
                color: color,
              ),
            ),
          ),
        ],
      );

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
                context,
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
                context,
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
