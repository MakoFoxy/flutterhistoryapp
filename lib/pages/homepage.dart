import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mausoleum/api/dropdawn_flag/dropdawn_flag.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => AppHomePage();
}

class AppHomePage extends State<HomePage> {
  @override
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[70],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'mytitlepage'.tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
        actions: [
          DropdawnFlag(changedLanguage: (value) {
            context.setLocale(Locale((value)));
          })
        ],
      ),
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
                Container(
                  height: MediaQuery.of(context).size.height - 89,
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
                var collRef = FirebaseFirestore.instance.collection('data');
                QuerySnapshot querySnapshot = await collRef.get();
                List<QueryDocumentSnapshot> docs = querySnapshot.docs;
                List<String> autokey = [];
                for (QueryDocumentSnapshot doc in docs) {
                  autokey.add(doc.id);
                }

                autokey.forEach((element) {
                  collRef.doc(element).delete();
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
      for (var keySnap in allResults) {
        var title = keySnap['title'].toString().toLowerCase();
        if (title.contains(keyword.text.toLowerCase())) {
          showRes.add(keySnap);
        }
      }
    } else {
      showRes = List.from(allResults);
    }

    setState(() {
      resultList = showRes;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('data')
        .orderBy('title')
        .get();

    setState(() {
      allResults = data.docs;
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
                hintText: 'Іздеу...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Mausoleum(),
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context)
                  .size
                  .height, // appBarHeight - это высота вашего AppBar
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Произошла ошибка');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('Нет данных');
        }
        final keysfirebase = snapshot.data?.docs.toList();

        if (resultList != "") {
          return Column(
            children: resultList.map((data) {
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

  // Widget _buildRating() => ListTile(
  //       title: Text(
  //         'Добавить в избранное',
  //         style: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.0,
  //         ),
  //       ),
  //       // subtitle: Text('Выбирите небходимый раздел'),
  //       trailing: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           FavoriteWidjet(),
  //         ],
  //       ),
  //     );

  Widget _buildAction() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButton("myhomepage".tr(), Icons.home, Colors.transparent),
          _buildButton("myQR".tr(), Icons.qr_code, Colors.transparent),
          _buildButton("mymap".tr(), Icons.map, Colors.transparent),
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

class FavoriteWidjet extends StatefulWidget {
  @override
  _FavoriteWidjetState createState() => _FavoriteWidjetState();
}

class _FavoriteWidjetState extends State<FavoriteWidjet> {
  bool _choiceFavor = false;
  int _favorCount = 123;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: IconButton(
            icon: (_choiceFavor
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border)),
            onPressed: _toggleFavorite,
            color: Colors.brown[500],
          ),
        ),
        SizedBox(
          width: 40,
          child: Container(
              child: Text(
            '$_favorCount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Увеличиваем размер шрифта на 24
              color: Colors.brown[500],
            ),
          )),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (_choiceFavor == true) {
        _choiceFavor = false;
        _favorCount = _favorCount - 1;
      } else {
        _choiceFavor = true;
        _favorCount = _favorCount + 1;
      }
    });
  }
}
