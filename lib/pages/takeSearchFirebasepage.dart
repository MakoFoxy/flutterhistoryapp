import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';

class takeSearchFirebasePage extends StatefulWidget {
  final String mykeyword;

  takeSearchFirebasePage({required this.mykeyword});

  @override
  State<takeSearchFirebasePage> createState() => _ApptakeSearchPage();
}

class _ApptakeSearchPage extends State<takeSearchFirebasePage> {
  int _backPressCount = 0;
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  String imageUrl = 'lib/assets/images/backgroundImages.jpg';
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
          child: DefaultTextStyle.merge(
            style: whiteTexstStyle,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
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
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: MyTakePage(
                      mykeyword: widget.mykeyword,
                      backgroundImage: DecorationImage(
                        image: AssetImage(imageUrl),
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
      ),
    );
  }
}

class MyTakePage extends StatefulWidget {
  String mykeyword;
  final DecorationImage backgroundImage;

  MyTakePage({required this.backgroundImage, required this.mykeyword, Key? key})
      : super(key: key);
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/backgroundImages.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FutureBuilder(
                builder: (context, snapshot) {
                  return FirebaseSearch(keyword: widget.mykeyword);
                },
                future: Future.delayed(const Duration(seconds: 1)),
              ),
            ),
          ),
        ],
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
            right: 120,
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
            right: 80,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapControlsPage(
                      id: "Қожа Ахмет Ясауи кесенесі",
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
  String keyword;

  FirebaseSearch({required this.keyword, Key? key}) : super(key: key);

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
    keyword.addListener(_onSearchChanged);
    super.initState();
    // mapdata = mapOver.mapdatas;
  }

  _onSearchChanged() {
    print(controlkey.text);
    searchResultList();
  }

  searchResultList() {
    var showRes = [];
    if (controlkey.text != "" || widget.keyword != "") {
      for (var keySnap in allResults) {
        var id = keySnap['id'].toString().toLowerCase();
        var title = keySnap['title'].toString().toLowerCase();
        if (id.contains(keyword.text.toLowerCase()) ||
            title.contains(keyword.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
    } else {
      showRes = List.from(allResults);
    }

    showRes.forEach((element) {
      print("showReselement $element");
    });

    setState(() {
      resultList = showRes;
    });
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
                    if (keyword.text == '') {
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
                streamBuild(resultList: resultList),
              ],
            ),
          ),
        ),
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
          return CircularProgressIndicator();
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
