import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mausoleum/videorepo/screens/splash_screen.dart';
import 'package:todo_repo/todo_repo.dart';
import 'package:todo_models/todo_model.dart';
import 'package:mausoleum/pages/editPages.dart';
import 'package:mausoleum/pages/homepage.dart';
import 'package:mausoleum/pages/takeSearchPage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/pages/editFirebasePages.dart';
import 'package:mausoleum/pages/takeSearchFirebasepage.dart';
import 'package:mausoleum/qrscanner.dart';

// Overview dataInform = Overview();

class QRobjectpage extends StatefulWidget {
  final String selectedKey; // Добавьте параметр для выбранного ключа
  final Function() closeScreen;

  QRobjectpage({
    super.key,
    required this.closeScreen, 
    required this.selectedKey,
  });

  @override
  State<QRobjectpage> createState() => _QRobjectpageState();
}

class _QRobjectpageState extends State<QRobjectpage> {
  // QueryDocumentSnapshot<Map<String, dynamic>>? editMydb;
  // QueryDocumentSnapshot<Map<String, dynamic>>? firebaseMyId;
  //List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebase;
  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    // fetchKeysFirebase();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.closeScreen();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: DefaultTextStyle(
          style: whiteTextStyle,
          child: Container(
            color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                mySearch(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MyTextCont(selectedKey: widget.selectedKey),
                    //MyPhotoCont(),
                  ],
                ),
                Expanded(
                  // Оберните ListView.builder в Expanded
                  child: ListView.builder(
                    itemCount: 1, // Замените itemCount на актуальное значение
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          MyPhotoCont(selectedKey: widget.selectedKey),
                          // const ScreenInit(),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: MyOverviews(
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
              },
              mini: true, // Установите mini: true для уменьшения размера кнопки
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Настройте форму кнопки
              ),
              child: const Icon(Icons.create),
            ),
          ),
          Positioned(
            left: 60,
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
              mini: true, // Установите mini: true для уменьшения размера кнопки
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Настройте форму кнопки
              ),
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
    qrKeysFirebase(); // Загрузите ключи из Firebase
    super.initState();
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  String discriptWidgets = "";
  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          discriptWidgets = autodata['description'];
        }
      }
    } catch (e) {
      print("Error qr object page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.amber,
          child: Text(
            discriptWidgets, // Убедиcь, что значение не null
            style: whiteTextStyle,
            textAlign: TextAlign.justify,
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
  // void initState() {
  //   super.initState();
  //   keywordAsyncFunction(keyword.text);
  // }

  // late List<TodoModel> resList = [];
  // Future<void> keywordAsyncFunction(String keyword) async {
  //   print("selectedKey1 $keyword");
  //   resList.clear(); // Очистите массив перед началом операций
  //   Future<List<TodoModel>> result = TodoRepository().searchDB(keyword);
  //   List<TodoModel> resultList = await result; // Дождитесь завершения Future
  //   for (int i = 0; i < resultList.length; i++) {
  //     if (resultList[i].title.contains(keyword)) {
  //       resList.add(resultList[i]);
  //     }
  //   }
  //   print("resultList $resList");
  //   print("resultList length ${resList.length}");
  // }

  String imageUrl = 'lib/assets/images/backgroundImages.jpg';

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
                            keyword: keyword.text);
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
    qrKeysFirebase(); // Загрузите ключи из Firebase
    super.initState();
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  String textWidgets = "";
  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          textWidgets = autodata['title'];
        }
      }
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
    qrKeysFirebase(); // Загрузите ключи из Firebase
    super.initState();
  }

  var collRef = FirebaseFirestore.instance.collection('data');

  String photoWidgets = "";
  Future<void> qrKeysFirebase() async {
    String targetQR = widget.selectedKey; // Значение, которое вы ищете
    try {
      QuerySnapshot querySnapshot = await collRef.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (QueryDocumentSnapshot doc in docs) {
        Map<String, dynamic> autodata = doc.data() as Map<String, dynamic>;
        String autokey = doc.id; // Получение ключа документа

        // Проверка, соответствует ли поле title значению, которое вы ищете
        if (autokey == targetQR) {
          photoWidgets = autodata['filephotopath'];
        }
      }
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

// class ScreenInit extends StatelessWidget {
//   const ScreenInit({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 720),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, widget) => MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: const SplashScreen(),
//           builder: (context, widget) {
//             ScreenUtil.registerToBuild(context);
//             return MediaQuery(
//                 data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                 child: widget!);
//           }),
//     );
//   }
// }