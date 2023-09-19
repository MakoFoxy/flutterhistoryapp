import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List resultList = []; // Объявите resultList здесь

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Set your preferred height here
        child: YoutubeAppBar(
          resultList: resultList,
          onResultListChanged: (resultList) {
            setState(() {
              resultList = resultList;
            });
          },
        ), // Use your custom app bar
      ),
      body: SafeArea(
        child: DefaultTextStyle.merge(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
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
                  child: MyHomePage(
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

class YoutubeAppBar extends StatefulWidget {
  final List<dynamic> resultList;
  final Function(List<dynamic>) onResultListChanged;

  YoutubeAppBar({
    required this.resultList,
    required this.onResultListChanged,
  });

  @override
  State<YoutubeAppBar> createState() => _YoutubeAppBarState();
}

class _YoutubeAppBarState extends State<YoutubeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        SizedBox(
          width: 185,
          child: FutureBuilder(
            builder: (context, snapshot) {
              return FirebaseSearch(
                resultList: widget.resultList,
                onResultListChanged: (resultList) {
                  setState(() {
                    resultList = resultList;
                  });
                },
              );
            },
            future: Future.delayed(const Duration(seconds: 1)),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.bookmark_add),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 12.0,
            backgroundImage: NetworkImage(
                'https://www.flutterant.com/wp-content/uploads/2020/07/satyam.jpg'),
            backgroundColor: Colors.transparent,
          ),
        )
      ],
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}

class FirebaseSearch extends StatefulWidget {
  List<dynamic> resultList;
  final Function(List<dynamic>) onResultListChanged; // Добавьте эту строку

  FirebaseSearch({
    required this.resultList,
    required this.onResultListChanged, // Добавьте эту строку
  });
  @override
  FirebaseSearchWidgetState createState() => FirebaseSearchWidgetState();
}

class FirebaseSearchWidgetState extends State<FirebaseSearch> {
  TextEditingController keyword = TextEditingController();

  List allResults = [];

  @override
  void initState() {
    keyword.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    if (keyword.text != "") {
      for (var keySnap in allResults) {
        var id = keySnap['id'].toString().toLowerCase();
        var title = keySnap['title'].toString().toLowerCase();
        if (id.contains(keyword.text.toLowerCase()) ||
            title.contains(keyword.text.toLowerCase())) {
          widget.resultList.add(keySnap);
        }
      }
    } else {
      widget.resultList = List.from(allResults);
    }
    setState(() {
      //widget.resultList = showRes;
      widget.onResultListChanged(widget.resultList);
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                controller: keyword,
                onSubmitted: (value) {
                  setState(() {
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 228,
            ),
            child: ListView(
              children: [
                StreamBuild(resultList: widget.resultList),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StreamBuild extends StatelessWidget {
  List<dynamic> resultList;

  StreamBuild({
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
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data');
        }
        final keysfirebase = snapshot.data?.docs.toList();

        if (resultList.isNotEmpty) {
          return Column(
            children: resultList.map((data) {
              final doc = data.data() as Map<String, dynamic>;
              return Container(
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
              );
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
              );
            }).toList(),
          );
        }
      },
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
  List resultList = [];

  @override
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final colorTextStyle = TextStyle(
      color: Color.fromARGB(255, 78, 82, 26),
      fontSize: 25,
    ); // Обновленный размер текста

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/backgroundImages.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 228,
              ),
              child: ListView(
                children: [
                  StreamBuild(resultList: resultList),
                ],
              ),
            ),
          ),
          // Container(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 5),
          //     child: FutureBuilder(
          //       builder: (context, snapshot) {
          //         return FirebaseSearch(
          //           resultList: resultList,
          //           onResultListChanged: (resultList) {
          //             setState(() {
          //               resultList = resultList;
          //             });
          //           },
          //         );
          //       },
          //       future: Future.delayed(const Duration(seconds: 1)),
          //     ),
          //   ),
          // ),
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
