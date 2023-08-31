import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mausoleum/components/sidebarmenu.dart';
import 'package:mausoleum/models/overview.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/models/overview.dart';
import 'package:mausoleum/models/generalwidgets.dart';
import 'package:mausoleum/models/createpost/createpostscree.dart';
import 'package:mausoleum/objectpage.dart';
import 'package:mausoleum/qrscanner.dart';
import 'package:todo_repo/todo_repo.dart';
import 'package:mausoleum/pages/editPages.dart';
import 'package:todo_models/todo_model.dart';
import 'package:todo_services/data_models/dbtodo.dart';
import 'package:mausoleum/models/generalwidgets.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';

class HomePage extends StatefulWidget {
  // List<TodoModel> resulterList;
  // HomePage({required this.resulterList});

  @override
  //State<HomePage> createState() => AppHomePage(resulterList: resulterList);
  State<HomePage> createState() => AppHomePage();
}

class AppHomePage extends State<HomePage> {
  String imageUrl = 'lib/assets/images/backgroundImages.jpg';
  // List<TodoModel> resulterList; // Добавьте это объявление
  // AppHomePage({required this.resulterList});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: MyHomePage(
                      //resulterList: resulterList, // Передаем resulterList сюда
                      backgroundImage: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
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

class MyHomePage extends StatefulWidget {
  // List<TodoModel> resulterList; // Добавьте это поле
  final DecorationImage backgroundImage;
  // MyHomePage(
  //     {required this.resulterList, required this.backgroundImage, Key? key})
  //     : super(key: key);
  MyHomePage({required this.backgroundImage, Key? key}) : super(key: key);

  @override
  //HomePageState createState() => HomePageState(resulterList: resulterList);
  HomePageState createState() => HomePageState();
}

//TextEditingController keyword = TextEditingController();
//TextEditingController firebasekeyword = TextEditingController();

class HomePageState extends State<MyHomePage> {
  // TextEditingController keyword = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   keyword = TextEditingController(); // Инициализируем контроллер
  // }

  // @override
  // void dispose() {
  //   keyword.dispose(); // Освобождаем контроллер при удалении виджета
  //   super.dispose();
  // }

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
              // future: keyword.text.length > 0
              //     ? TodoRepository().searchDB(keyword.text)
              //     : TodoRepository().getAllTodo(),
              builder: (context, snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else if (snapshot.hasError) {
            //   // Обработка ошибок при загрузке данных.
            //   return Text("Ошибка при загрузке данных");
            // } else if (!snapshot.hasData) {
            //   return Text("Нет данных");
            // } else {
            // Данные успешно загружены, отображаем их.
            // List<TodoModel> data = snapshot.data as List<TodoModel>;
            // return Column(
            //   children: [
            //     Container(
            //       width: double.infinity,
            //       height: 40,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: Center(
            //         child: TextField(
            //           controller: keyword,
            //           onSubmitted: (value) {
            //             setState(() {
            //               // ignore: unrelated_type_equality_checks
            //               keyword.text = value;
            //             });
            //           },
            //           decoration: InputDecoration(
            //             prefixIcon: IconButton(
            //               icon: const Icon(Icons.search),
            //               onPressed: () {
            //                 setState(() {
            //                   TodoRepository().searchDB(keyword.text);
            //                 });
            //               },
            //             ),
            //             suffixIcon: IconButton(
            //               icon: const Icon(Icons.clear),
            //               onPressed: () {
            //                 keyword.text = '';
            //               },
            //             ),
            //             hintText: 'Іздеу...',
            //             border: InputBorder.none,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Mausoleum(),
            //     Expanded(
            //       child: ListView.separated(
            //         itemCount: data.length,
            //         separatorBuilder: (context, index) =>
            //             SizedBox(height: 10),
            //         itemBuilder: (context, index) {
            //           return Container(
            //             margin: const EdgeInsets.only(left: 50, right: 50),
            //             padding: const EdgeInsets.symmetric(vertical: 5),
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 // Обработчик нажатия кнопки с ключом
            //                 print(
            //                     'Нажата кнопка с ключом: ${data[index].letId}');
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => ObjectPage(
            //                         selectedId: data[index].letId,
            //                         selectedKey: data[index].title),
            //                   ),
            //                 );
            //               },
            //               style: ElevatedButton.styleFrom(
            //                 primary: Colors.amber.withOpacity(0.8),
            //                 padding: const EdgeInsets.symmetric(
            //                   vertical: 10,
            //                   horizontal: 30,
            //                 ),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(30),
            //                 ),
            //               ),
            //               child: Text(
            //                 // resulterList != null
            //                 //     ? resulterList[index].title
            //                 data[index].title,
            //                 //  ? data[index].title
            //                 // : widget.resulterList[index].title,
            //                 style: colorTextStyle,
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            return FirebaseSearch();
            //   ],
            // );
          }),
        ),
      ),
      //     ),
      //   ),
      // ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              heroTag: "create",
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
              heroTag: "delete",
              onPressed: () async {
                // setState(() {
                //   TodoRepository().deleteAlltables();
                // });
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
          Positioned(
            right: 120,
            bottom: 0,
            child: FloatingActionButton(
              heroTag: "qrscanner",
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
        ],
      ),
    );
  }
}

class FirebaseSearch extends StatefulWidget {
  // const FirebaseSearch({Key? key}) : super(key: key);
  @override
  FirebaseSearchWidget createState() => FirebaseSearchWidget();
}

class FirebaseSearchWidget extends State<FirebaseSearch> {
  TextEditingController keyword = TextEditingController();

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
                hintText: 'Іздеу...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Mausoleum(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(// Один элемент, ваш streamBuild
                children: [
              streamBuild(resultList: resultList),
            ]),
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
            // Оберните ListView.builder в Expanded
            children: resultList.map((data) {
              final doc = data.data() as Map<String, dynamic>;
              return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Hero(
                    tag: doc['title'], // Use the title as the heroTag
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
                  tag: doc['title'], // Use the title as the heroTag
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
        'Мавзолей',
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
    return Expanded(
      child: Container(
        // padding: const EdgeInsets.only(left: 0, right: 0),
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


// class sqfliteSearch extends StatefulWidget {
//   List<TodoModel> data; // Добавьте поле для хранения списка data

//   // Конструктор для передачи данных
//   sqfliteSearch({required this.data});
//   @override
//   State<sqfliteSearch> createState() => sqfliteSearchState();
// }

// class sqfliteSearchState extends State<sqfliteSearch> {
//   @override
//   final colorTextStyle = TextStyle(color: Colors.white, fontSize: 24);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Center(
//             child: TextField(
//               controller: keyword,
//               onSubmitted: (value) {
//                 setState(() {
//                   // ignore: unrelated_type_equality_checks
//                   keyword.text = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 prefixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     setState(() {
//                       TodoRepository().searchDB(keyword.text);
//                     });
//                   },
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.clear),
//                   onPressed: () {
//                     keyword.text = '';
//                   },
//                 ),
//                 hintText: 'Іздеу...',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//         Mausoleum(),
//         Expanded(
//           child: ListView.separated(
//             itemCount: widget.data.length,
//             separatorBuilder: (context, index) => SizedBox(height: 10),
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: const EdgeInsets.only(left: 50, right: 50),
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Обработчик нажатия кнопки с ключом
//                     print(
//                         'Нажата кнопка с ключом: ${widget.data[index].letId}');
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ObjectPage(
//                             selectedId: widget.data[index].letId,
//                             selectedKey: widget.data[index].title),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.amber.withOpacity(0.8),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: 30,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     // resulterList != null
//                     //     ? resulterList[index].title
//                     widget.data[index].title,
//                     //  ? data[index].title
//                     // : widget.resulterList[index].title,
//                     style: colorTextStyle,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
