import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> onResultListChanged = [];

  void handleResultListChanged(List<dynamic> resultList) {
    setState(() {
      onResultListChanged = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Set your preferred height here
        child: MyAppBar(
          onResultListChanged: handleResultListChanged,
        ), // Use your custom app bar
      ),
      body: SafeArea(
        child: DefaultTextStyle.merge(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 128,
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: MyHomePage(
                    resultListHome: onResultListChanged,
                    backgroundImage: DecorationImage(
                      image:
                          AssetImage('lib/assets/images/backgroundImages.jpg'),
                      fit: BoxFit.cover,
                    ),
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
    );
  }
}

class MyAppBar extends StatefulWidget {
  final ValueChanged<List<dynamic>> onResultListChanged;

  MyAppBar({
    required this.onResultListChanged,
  });

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
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 290,
            child: FutureBuilder(
              builder: (context, snapshot) {
                return FirebaseSearch(
                  onResultListChanged: widget.onResultListChanged,
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

class FirebaseSearch extends StatefulWidget {
  final ValueChanged<List<dynamic>>
      onResultListChanged; // Изменили тип на ValueChanged

  FirebaseSearch({
    required this.onResultListChanged,
  });

  @override
  FirebaseSearchWidget createState() => FirebaseSearchWidget();
}

class FirebaseSearchWidget extends State<FirebaseSearch> {
  TextEditingController keyword = TextEditingController();

  List allResults = [];
  List resultList = [];

  @override
  void initState() {
    keyword.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(keyword.text);
    searchResultList();
  }

  searchResultList() {
    var showRes = [];
    if (keyword.text != "") {
      var keywords = keyword.text.toLowerCase().split(" ");
      for (var keySnap in allResults) {
        var id = keySnap['id'].toString().toLowerCase();
        var title = keySnap['title'].toString().toLowerCase();
        var description = keySnap['description'].toString().toLowerCase();
        bool found = false;
        for (var kw in keywords) {
          if (id.contains(kw) ||
              title.contains(kw) ||
              description.contains(kw)) {
            found = true;
            break;
          }
        }
        if (found) {
          showRes.add(keySnap);
        }
      }
      print('showRes $showRes');
    } else {
      // for (var keySnap in allResults) {
      //   var id = keySnap['id'].toString();
      //   var title = keySnap['title'].toString();
      //   var description = keySnap['description'].toString();
      //   print("ID: $id TITLE doc: $title DESCRIPTION: $description");
      // }
      showRes = List.from(allResults);
    }

    showRes.forEach((element) {
      print("showRes element $element");
    });

    setState(() {
      resultList = showRes;
    });

    widget.onResultListChanged(resultList);

    print('widget.onResultListChanged ${widget.onResultListChanged}');
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
    });
    searchResultList();
  }

  @override
  void dispose() {
    keyword.removeListener(_onSearchChanged);
    keyword.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5, // Устанавливаем отступ сверху
        ),
        Container(
          width: double.infinity,
          height: 45,
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
                    if (keyword.text != '') {
                      setState(() {
                        getClientStream();
                      });
                    } else if (keyword.text == '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
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
        ),
        SizedBox(
          height: 5, // Устанавливаем отступ сверху
        ),
        // Mausoleum(),
        // SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       maxHeight: MediaQuery.of(context).size.height -
        //           518, // appBarHeight - это высота вашего AppBar
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
}

class streamBuild extends StatelessWidget {
  List<dynamic> resultList;

  streamBuild({
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

    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data');
        }

        if (resultList != "") {
          return Container(
            child: Row(
              // Use curly braces here instead of parentheses
              children: resultList.map((data) {
                final doc = data.data() as Map<String, dynamic>;
                return Container(
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
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
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ]),
                );
              }).toList(),
            ),
          );
        }
        return Container();
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
                  color: Colors.white,
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

class MyHomePage extends StatefulWidget {
  final List<dynamic> resultListHome;
  final DecorationImage backgroundImage;
  MyHomePage(
      {required this.backgroundImage, required this.resultListHome, Key? key})
      : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  //List resultList = [];

  @override
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final colorTextStyle = TextStyle(
      color: Color.fromARGB(255, 78, 82, 26),
      fontSize: 25,
    ); // Обновленный размер текста
    print('widget.onResultListChanged2 ${widget.resultListHome}');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: ConstrainedBox(
            //       constraints: BoxConstraints(
            //         maxHeight: MediaQuery.of(context).size.height -
            //             228, // appBarHeight - это высота вашего AppBar
            //       ),
            //       child: Row(
            //         children: [
            //           streamBuild(resultList: widget.resultListHome),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height +
                      26500, // appBarHeight - это высота вашего AppBar
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
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateHistoryPost(),
                  ),
                );
              },
              child: const Icon(Icons.create),
            ),
          ),
          // Positioned(
          //   left: 20,
          //   bottom: 0,
          //   child: FloatingActionButton(
          //     onPressed: () async {
          //       var collRefkz = FirebaseFirestore.instance.collection('datakz');
          //       var collRefru = FirebaseFirestore.instance.collection('dataru');
          //       var collRefen = FirebaseFirestore.instance.collection('dataen');

          //       QuerySnapshot querySnapshotkz = await collRefkz.get();
          //       QuerySnapshot querySnapshotru = await collRefru.get();
          //       QuerySnapshot querySnapshoten = await collRefen.get();

          //       List<QueryDocumentSnapshot> docskz = querySnapshotkz.docs;
          //       List<QueryDocumentSnapshot> docsru = querySnapshotru.docs;
          //       List<QueryDocumentSnapshot> docsen = querySnapshoten.docs;

          //       List<String> autokey = [];
          //       for (QueryDocumentSnapshot doc in docskz) {
          //         autokey.add(doc.id);
          //       }
          //       for (QueryDocumentSnapshot doc in docsru) {
          //         autokey.add(doc.id);
          //       }
          //       for (QueryDocumentSnapshot doc in docsen) {
          //         autokey.add(doc.id);
          //       }

          //       autokey.forEach((element) {
          //         collRefkz.doc(element).delete();
          //       });
          //       autokey.forEach((element) {
          //         collRefru.doc(element).delete();
          //       });
          //       autokey.forEach((element) {
          //         collRefen.doc(element).delete();
          //       });
          //     },
          //     child: const Icon(Icons.delete),
          //   ),
          // ),
        ],
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

// class FavoriteWidjet extends StatefulWidget {
//   @override
//   _FavoriteWidjetState createState() => _FavoriteWidjetState();
// }

// class _FavoriteWidjetState extends State<FavoriteWidjet> {
//   bool _choiceFavor = false;
//   int _favorCount = 123;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           child: IconButton(
//             icon: (_choiceFavor
//                 ? Icon(Icons.favorite)
//                 : Icon(Icons.favorite_border)),
//             onPressed: _toggleFavorite,
//             color: Colors.brown[500],
//           ),
//         ),
//         SizedBox(
//           width: 40,
//           child: Container(
//               child: Text(
//             '$_favorCount',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20, // Увеличиваем размер шрифта на 24
//               color: Colors.brown[500],
//             ),
//           )),
//         ),
//       ],
//     );
//   }

//   void _toggleFavorite() {
//     setState(() {
//       if (_choiceFavor == true) {
//         _choiceFavor = false;
//         _favorCount = _favorCount - 1;
//       } else {
//         _choiceFavor = true;
//         _favorCount = _favorCount + 1;
//       }
//     });
//   }
// }

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
