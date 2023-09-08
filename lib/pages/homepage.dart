import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => AppHomePage();
}

class AppHomePage extends State<HomePage> {
  @override
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle.merge(
          style: whiteTexstStyle,
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('lib/assets/images/backgroundImages.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
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
                Container(
                  height: MediaQuery.of(context).size.height - 145,
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('lib/assets/images/backgroundImages.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: MyHomePage(
                    //resulterList: resulterList, // Передаем resulterList сюда
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

class MyHomePage extends StatefulWidget {
  final DecorationImage backgroundImage;
  MyHomePage({required this.backgroundImage, Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  @override
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final colorTextStyle = TextStyle(
      color: Color.fromARGB(255, 78, 82, 26),
      fontSize: 25,
    ); // Обновленный размер текста
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/backgroundImages.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: FutureBuilder(
            builder: (context, snapshot) {
              return FirebaseSearch();
            },
            future: Future.delayed(const Duration(seconds: 1)),
          ),
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
          Positioned(
            left: 20,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                var collRefkz = FirebaseFirestore.instance.collection('datakz');
                var collRefru = FirebaseFirestore.instance.collection('dataru');
                var collRefen = FirebaseFirestore.instance.collection('dataen');

                QuerySnapshot querySnapshotkz = await collRefkz.get();
                QuerySnapshot querySnapshotru = await collRefru.get();
                QuerySnapshot querySnapshoten = await collRefen.get();

                List<QueryDocumentSnapshot> docskz = querySnapshotkz.docs;
                List<QueryDocumentSnapshot> docsru = querySnapshotru.docs;
                List<QueryDocumentSnapshot> docsen = querySnapshoten.docs;

                List<String> autokey = [];
                for (QueryDocumentSnapshot doc in docskz) {
                  autokey.add(doc.id);
                }
                for (QueryDocumentSnapshot doc in docsru) {
                  autokey.add(doc.id);
                }
                for (QueryDocumentSnapshot doc in docsen) {
                  autokey.add(doc.id);
                }

                autokey.forEach((element) {
                  collRefkz.doc(element).delete();
                });
                autokey.forEach((element) {
                  collRefru.doc(element).delete();
                });
                autokey.forEach((element) {
                  collRefen.doc(element).delete();
                });
              },
              child: const Icon(Icons.delete),
            ),
          ),
          Positioned(
            right: 160,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScanner(),
                  ),
                );
              },
              child: const Icon(Icons.qr_code_scanner),
            ),
          ),
          Positioned(
            right: 80,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapControlsPage(
                      title: "Қожа Ахмет Ясауи кесенесі",
                      selectedX: 43.29785383147346,
                      selectedY: 68.27119119202341,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.map),
            ),
          ),
        ],
      ),
    );
  }
}

class FirebaseSearch extends StatefulWidget {
  @override
  FirebaseSearchWidget createState() => FirebaseSearchWidget();
}

class FirebaseSearchWidget extends State<FirebaseSearch> {
  TextEditingController keyword = TextEditingController();

  List allResultsKz = [];
  List allResultsRu = [];
  List allResultsEn = [];
  List resultList = [];
  String currentLanguagekz = 'kk';
  String currentLanguageru = 'ru';
  String currentLanguageen = 'en';

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
      for (var keySnap in allResultsKz) {
        var title = keySnap['title'].toString().toLowerCase();
        if (title.contains(keyword.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
      for (var keySnap in allResultsRu) {
        var title = keySnap['title'].toString().toLowerCase();
        if (title.contains(keyword.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
      for (var keySnap in allResultsEn) {
        var title = keySnap['title'].toString().toLowerCase();
        if (title.contains(keyword.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
    } else {
      if (Localizations.localeOf(context).languageCode == currentLanguagekz) {
        showRes = List.from(allResultsKz);
      } else if (Localizations.localeOf(context).languageCode ==
          currentLanguageru) {
        showRes = List.from(allResultsRu);
      } else if (Localizations.localeOf(context).languageCode ==
          currentLanguageen) {
        showRes = List.from(allResultsEn);
      }
    }
    setState(() {
      resultList = showRes;
    });
  }

  getClientStream() async {
    late QuerySnapshot<Map<String, dynamic>> datalinguakz;
    late QuerySnapshot<Map<String, dynamic>> datalinguaru;
    late QuerySnapshot<Map<String, dynamic>> datalinguaen;
    if (Localizations.localeOf(context).languageCode == currentLanguagekz) {
      datalinguakz = await FirebaseFirestore.instance
          .collection('datakz')
          .orderBy('title')
          .get();
      datalinguaru = await FirebaseFirestore.instance
          .collection('dataru')
          .orderBy('title')
          .get();
      datalinguaen = await FirebaseFirestore.instance
          .collection('dataen')
          .orderBy('title')
          .get();
    } else if (Localizations.localeOf(context).languageCode ==
        currentLanguageru) {
      datalinguakz = await FirebaseFirestore.instance
          .collection('datakz')
          .orderBy('title')
          .get();
      datalinguaru = await FirebaseFirestore.instance
          .collection('dataru')
          .orderBy('title')
          .get();
      datalinguaen = await FirebaseFirestore.instance
          .collection('dataen')
          .orderBy('title')
          .get();
    } else if (Localizations.localeOf(context).languageCode ==
        currentLanguageen) {
      datalinguakz = await FirebaseFirestore.instance
          .collection('datakz')
          .orderBy('title')
          .get();
      datalinguaru = await FirebaseFirestore.instance
          .collection('dataru')
          .orderBy('title')
          .get();
      datalinguaen = await FirebaseFirestore.instance
          .collection('dataen')
          .orderBy('title')
          .get();
    }
    setState(() {
      allResultsKz = datalinguakz.docs;
      allResultsRu = datalinguaru.docs;
      allResultsEn = datalinguaen.docs;
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
        Container(
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
                    setState(() {
                      getClientStream();
                    });
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
        Mausoleum(),
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  228, // appBarHeight - это высота вашего AppBar
            ),
            child: ListView(
              children: [
                streamBuild(
                  resultList: resultList,
                  currentLanguagekz: currentLanguagekz,
                  currentLanguageru: currentLanguageru,
                  currentLanguageen: currentLanguageen,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class streamBuild extends StatelessWidget {
  List<dynamic> resultList = [];
  String currentLanguagekz; // Добавьте текущий языковой параметр
  String currentLanguageru; // Добавьте текущий языковой параметр
  String currentLanguageen; // Добавьте текущий языковой параметр

  streamBuild({
    required this.resultList,
    required this.currentLanguagekz,
    required this.currentLanguageru,
    required this.currentLanguageen,
  });

  @override
  final colorTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    print('resultList ${resultList.asMap()}');
    late Stream<QuerySnapshot<Map<String, dynamic>>> datastream;
    if (Localizations.localeOf(context).languageCode == currentLanguagekz) {
      datastream = FirebaseFirestore.instance.collection('datakz').snapshots();
    } else if (Localizations.localeOf(context).languageCode ==
        currentLanguageru) {
      datastream = FirebaseFirestore.instance.collection('dataru').snapshots();
    } else if (Localizations.localeOf(context).languageCode ==
        currentLanguageen) {
      datastream = FirebaseFirestore.instance.collection('dataen').snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: datastream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data');
        }
        final keysfirebase = snapshot.data?.docs.toList();

        if (resultList != "") {
          return Column(
            children: resultList.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final doc = data.data() as Map<String, dynamic>;
              final tag =
                  'title_${doc['title']}_$index'; // Уникальный тег с индексом

              return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Hero(
                    tag: tag,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectFirebasePage(
                              selectedKey: doc['title'],
                              currentLanguagekz: currentLanguagekz,
                              currentLanguageru: currentLanguageru,
                              currentLanguageen: currentLanguageen,
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
                  tag: 'title_${doc['title']}',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObjectFirebasePage(
                            selectedKey: doc['title'],
                            currentLanguagekz: currentLanguagekz,
                            currentLanguageru: currentLanguageru,
                            currentLanguageen: currentLanguageen,
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
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class Mausoleum extends StatelessWidget {
  @override
  final colorTextStyle = TextStyle(color: Colors.black, fontSize: 24);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 134, 133, 45),
            blurRadius: 40,
            offset: Offset(1, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 67, 83, 68),
          Color.fromARGB(255, 67, 83, 68),
          Color.fromARGB(255, 67, 83, 68),
        ]),
      ),
      child: Text(
        'mytitlepage'.tr(),
        textAlign: TextAlign.center,
        style: colorTextStyle,
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
