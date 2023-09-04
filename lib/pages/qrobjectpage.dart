import 'package:flutter/material.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/editFirebasePages.dart';
import 'package:mausoleum/pages/takeSearchFirebasepage.dart';
import 'package:mausoleum/pages/qrscanner.dart';
import 'dart:io';
import 'package:mausoleum/api/yandexmap/map_controls_page.dart';

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
  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  // void initState() {
  //   widget.closeScreen();
  //   super.initState();
  //   // mapdata = mapOver.mapdatas;
  // }
  @override
  Widget build(BuildContext context) {
    // widget.closeScreen();
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: whiteTextStyle,
          child: Container(
            color: Colors.amber,
            child: ListView(
              children: <Widget>[
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
                late String keyforedit;
                var collRef = FirebaseFirestore.instance.collection('data');
                String targetTitle =
                    widget.selectedKey; // Значение, которое вы ищете

                QuerySnapshot querySnapshot = await collRef.get();
                List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                for (QueryDocumentSnapshot doc in docs) {
                  Map<String, dynamic> autodata =
                      doc.data() as Map<String, dynamic>;
                  String autokey = doc.id; // Получение ключа документа
                  // Проверка, соответствует ли поле title значению, которое вы ищете
                  if (autokey == targetTitle) {
                    keyforedit = autodata['title'];
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
                var collRef = FirebaseFirestore.instance.collection('data');
                String targetTitle =
                    widget.selectedKey; // Значение, которое вы ищете

                QuerySnapshot querySnapshot = await collRef.get();
                List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                for (QueryDocumentSnapshot doc in docs) {
                  String autokey = doc.id; // Получение ключа документа
                  // Проверка, соответствует ли поле title значению, которое вы ищете
                  if (autokey == targetTitle) {
                    await collRef.doc(autokey).delete();
                    print("Document deleted: $autokey");
                    break; // Прерываем цикл после обновления первого соответствующего документа
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

  MyOverviews({
    //required this.mapdata,
    required this.selectedKey,
  });

  @override
  State<MyOverviews> createState() => MyOverviewsState();
}

class MyOverviewsState extends State<MyOverviews> {
  final whiteTextStyle =
      TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20);

  void initState() {
    super.initState();
    qrKeysFirebase(); // Загрузите ключи из Firebase
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  String discriptWidgets = "";
  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      String newDescription = "";

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          newDescription = autodata['description'];
        }
      }
      setState(() {
        discriptWidgets = newDescription;
      });
    } catch (e) {
      print("Error qr object page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Text(
        discriptWidgets ?? '',
        style: whiteTextStyle,
        textAlign: TextAlign.justify,
      ),
    );
  }
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

  void initState() {
    super.initState();
    qrKeysFirebase(); // Загрузите ключи из Firebase
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  late double xCoordinateWidget;
  late double yCoordinateWidget;

  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      late double xCoordinate;
      late double yCoordinate;

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          xCoordinate = autodata['xCoordinate'];
          yCoordinate = autodata['yCoordinate'];
        }
      }
      setState(() {
        xCoordinateWidget = xCoordinate;
        yCoordinateWidget = yCoordinate;
      });
    } catch (e) {
      print("Error qr object page: $e");
    }
  }

  Widget build(BuildContext context) {
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
                selectedX: xCoordinateWidget,
                selectedY: yCoordinateWidget,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (keyword.text != '') {
                        String mykeyword = keyword.text;
                        return takeSearchFirebasePage(mykeyword: mykeyword);
                      } else {
                        return HomePage();
                      }
                    },
                  ),
                );
                print('keyword.text ${keyword.text}');
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
    );
  }
}

class MyTextCont extends StatefulWidget {
  String selectedKey;

  MyTextCont({required this.selectedKey});

  @override
  State<MyTextCont> createState() => MyTextContState();
}

class MyTextContState extends State<MyTextCont> {
  void initState() {
    super.initState();
    qrKeysFirebase(); // Загрузите ключи из Firebase
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  String textWidgets = "";
  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      String newDescription = "";

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          newDescription = autodata['title'];
        }
      }
      setState(() {
        textWidgets = newDescription;
      });
    } catch (e) {
      print("Error qr object page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      alignment: Alignment.center,
      color: Colors.amber,
      child: Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        color: Colors.amber,
        child: Text(
          textWidgets,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
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
  void initState() {
    super.initState();
    qrKeysFirebase(); // Загрузите ключи из Firebase
  }

  var collRef = FirebaseFirestore.instance.collection('data');
  String photoWidgets = "";

  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      String newDescription = "";

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          newDescription = autodata['filephotopath'];
        }
      }
      setState(() {
        photoWidgets = newDescription;
      });
    } catch (e) {
      print("Error qr object page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 340,
      child: Card(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          // child: Text('No image'),
          child: Image.file(
            File(photoWidgets),
            fit: BoxFit.cover,
          ),
        ),
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
    return Column(
      children: <Widget>[
        Container(
          color: Colors.amber,
          margin: const EdgeInsets.all(0),
          child: _buildRating(),
        ),
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(0),
          child: Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(0),
            child: _buildAction(),
          ),
        ),
      ],
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
