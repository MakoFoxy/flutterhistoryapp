import 'package:flutter/material.dart';
import 'package:mausoleum/pages/createpostscree.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:mausoleum/pages/qrscanner.dart';

class takeSearchFirebasePage extends StatefulWidget {
  final String mykeyword;

  takeSearchFirebasePage({required this.mykeyword});

  @override
  State<takeSearchFirebasePage> createState() => _ApptakeSearchPage();
}

class _ApptakeSearchPage extends State<takeSearchFirebasePage> {
  final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

  String imageUrl = 'lib/assets/images/backgroundImages.jpg';
  @override
  Widget build(BuildContext context) {
    String mykeyword = widget.mykeyword;    

    print('keywordnowright $keyword');

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
                Container(
                  height: MediaQuery.of(context).size.height - 89,
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: MyTakePage(
                    keyword: mykeyword,
                    backgroundImage: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  //height: 118,
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

class MyTakePage extends StatefulWidget {
  String keyword;
  final DecorationImage backgroundImage;

  MyTakePage({required this.backgroundImage, required this.keyword, Key? key})
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
                  return FirebaseSearch(keyword: widget.keyword);
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
                var collRef = FirebaseFirestore.instance.collection('data');
                QuerySnapshot querySnapshot = await collRef.get();
                List<QueryDocumentSnapshot> docs = querySnapshot.docs;
                List<String> autokey = [];
                for (QueryDocumentSnapshot doc in docs) {
                  autokey.add(doc.id);
                }
                // for(int i = 0; i < autokey.length; i++) {
                //   collRef.doc(autokey[i]).delete();
                // }
                autokey.forEach((element) {
                  collRef.doc(element).delete();
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

class FirebaseSearch extends StatefulWidget {
  String keyword;

  FirebaseSearch({required this.keyword, Key? key}) : super(key: key);

  // const FirebaseSearch({Key? key}) : super(key: key);
  @override
  FirebaseSearchWidget createState() => FirebaseSearchWidget();
}

class FirebaseSearchWidget extends State<FirebaseSearch> {
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
                margin: const EdgeInsets.only(left: 50, right: 50),
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ObjectFirebasePage(
                    //       selectedKey: doc['title'],
                    //     ),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    doc['title'],
                    style: colorTextStyle,
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
                margin: const EdgeInsets.only(left: 50, right: 50),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ObjectFirebasePage(
                    //       selectedKey: doc['title'],
                    //     ),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    doc['title'],
                    style: colorTextStyle,
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
          // Container(
          //   color: Colors.amber[500],
          //   margin: const EdgeInsets.all(0),
          //   child: _buildRating(),
          // ),
          SizedBox(height: 0),
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(0),
            child: Container(
              color: Colors.amber,
              padding: const EdgeInsets.all(10),
              child: _buildAction(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 231, 177, 15),
        border: Border.all(),
      ),
    );
  }

  Widget _buildRating() => ListTile(
        title: Text(
          'Добавить в избранное',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        // subtitle: Text('Выбирите небходимый раздел'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FavoriteWidjet(),
          ],
        ),
      );

  Widget _buildAction() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButton("Меню", Icons.menu, Colors.transparent),
          _buildButton("Карта", Icons.map, Colors.transparent),
          _buildButton("Избранное", Icons.favorite, Colors.transparent),
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
            color: Colors.brown,
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
