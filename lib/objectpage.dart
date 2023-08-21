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

// Overview dataInform = Overview();

class ObjectPage extends StatefulWidget {
  //final Map<String, String> mapdata;
  final String selectedKey; // Добавьте параметр для выбранного ключа
  final int selectedId; // Добавьте параметр для выбранного ключа
  ObjectPage({
    required this.selectedKey,
    required this.selectedId,
  });

  @override
  State<ObjectPage> createState() => _ObjectPage();
}

class _ObjectPage extends State<ObjectPage> {
  @override
  final whiteTextStyle = TextStyle(color: Colors.white, fontSize: 24);

  @override
  void initState() {
    super.initState();
    asyncFunction(widget.selectedKey);
  }

  TodoModel editRes = TodoModel(
    letId: 0,
    title: "",
    description: "",
    filephotopath: "",
  );

  int resultID = 0;
  Future<void> asyncFunction(String selectedKey) async {
    print("selectedKey $selectedKey");
    Future<List<TodoModel>> result = TodoRepository().searchDB(selectedKey);
    List<TodoModel> resultList = await result; // Дождитесь завершения Future

    for (int i = 0; i < resultList.length; i++) {
      print("resultList.length ${resultList.length}");
      if (resultList[i].title == selectedKey) {
        setState(() {
          resultID = resultID + resultList[i].letId;
          editRes = resultList[i];
        });
        print(resultID);
      }
    }
    print("selectedId info ${editRes}");
    print("resultID info $resultID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          const ScreenInit(),
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
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditPage(
                      modelDB: editRes,
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
          Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 0.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  TodoRepository().deleteElemById(resultID);
                });
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
  State<MyOverviews> createState() => _MyOverviewsState();
}

class _MyOverviewsState extends State<MyOverviews> {
  final whiteTextStyle =
      TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20);

  @override
  void initState() {
    super.initState();
    someAsyncFunction(widget.selectedKey);
  }

  String resultDiscription = "";
  Future<void> someAsyncFunction(String selectedKey) async {
    print("selectedKey1 $selectedKey");
    Future<List<TodoModel>> result = TodoRepository().searchDB(selectedKey);
    List<TodoModel> resultList = await result; // Дождитесь завершения Future

    for (int i = 0; i < resultList.length; i++) {
      print("resultList.length ${resultList.length}");
      if (resultList[i].title == selectedKey) {
        setState(() {
          resultDiscription = resultDiscription + resultList[i].description;
        });
        print(resultDiscription);
      }
    }
    print("selectedKey info ${widget.selectedKey}");
    print("resultDiscription info $resultDiscription");
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Показываем индикатор загрузки во время ожидания данных
        }

        if (snapshot.hasError) {
          return Text("Ошибка: ${snapshot.error}");
        }
        final clients = snapshot.data?.docs.reversed.toList();

        return ListView.builder(
          itemCount: clients?.length ?? 0,
          //itemCount: 1,
          itemBuilder: (context, index) {
           final data = clients![index];
            // String value = mapdata[selectedKey] ?? "";
            print(widget.selectedKey);
            print(resultDiscription);
            Card(
              color: Colors.amber,
              elevation: 5,
              child: Container(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 0), // Убираем отступы по бокам
                color: Colors.amber,
                child: Text(
                  resultDiscription,
                  style: whiteTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
            );
            Card(
              child: Container(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 0), // Убираем отступы по бокам
                color: Colors.amber,
                child: Text(
                  data['description'],
                  style: whiteTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
            );
            // child: Column(
            //   children: [
            //     Container(
            //       color: Colors.amber,
            //       child: Text(
            //         resultDiscription,
            //         style: whiteTextStyle,
            //         textAlign: TextAlign.justify,
            //       ),
            //     ),
            //   ],
            // ),
          },
        );
      },
    );
  }
}

// Container(
//   // padding: const EdgeInsets.symmetric(
//   //     horizontal: 0), // Убираем отступы по бокам
//   color: Colors.amber,
//   child: Text(
//     data['description'],
//     style: whiteTextStyle,
//     textAlign: TextAlign.justify,
//   ),
// ),

class ScreenInit extends StatelessWidget {
  const ScreenInit({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          builder: (context, widget) {
            ScreenUtil.registerToBuild(context);
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          }),
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

  late List<TodoModel> resList = [];
  Future<void> keywordAsyncFunction(String keyword) async {
    print("selectedKey1 $keyword");
    resList.clear(); // Очистите массив перед началом операций
    Future<List<TodoModel>> result = TodoRepository().searchDB(keyword);
    List<TodoModel> resultList = await result; // Дождитесь завершения Future
    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].title.contains(keyword)) {
        resList.add(resultList[i]);
      }
    }
    print("resultList $resList");
    print("resultList length ${resList.length}");
  }

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
                setState(() {
                  keywordAsyncFunction(keyword.text);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (keyword.text != '') {
                        return takeSearchPage(
                          resList: resList,
                        );
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

class MyTextCont extends StatelessWidget {
  String selectedKey;

  MyTextCont({required this.selectedKey});

  // Future<void> keywordAsyncFunction(String selectedKey) async {
  //   Future<List<TodoModel>> myres = TodoRepository().searchDB(selectedKey);
  //   List<TodoModel> myresList = await myres; // Дождитесь завершения Future
  //   for (int i = 0; i < myresList.length; i++) {
  //     if (myresList[i].title == selectedKey) {
  //       selectedKey = myresList[i].title;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //  keywordAsyncFunction(selectedKey);
    return Container(
      width: 350,
      alignment: Alignment.center,
      color: Colors.amber,
      child: Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        color: Colors.amber,
        child: Text(
          selectedKey,
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
  @override
  void initState() {
    super.initState();
    photoAsyncFunction(widget.selectedKey);
  }

  String resultPhoto = "";

  Future<void> photoAsyncFunction(String selectedKey) async {
    print("selectedKey1 $selectedKey");
    Future<List<TodoModel>> result = TodoRepository().searchDB(selectedKey);
    List<TodoModel> resultList = await result; // Дождитесь завершения Future

    for (int i = 0; i < resultList.length; i++) {
      print("resultList.length ${resultList.length}");
      if (resultList[i].title == selectedKey) {
        setState(() {
          resultPhoto = resultList[i].filephotopath;
        });
        print(resultPhoto);
      }
    }
    print("selectedKey info ${widget.selectedKey}");
    print("resultPhoto info $resultPhoto");
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
          child: Image.file(
            File(resultPhoto),
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
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

// class BoxMenu extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Меню',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }

// class SearchBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Поиск',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }

// class LinguaBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Язык',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }

// String myfunc(String selectedKey) {
//   for (var key in mapdata.keys) {
//     if (key == selectedKey) {
//       return mapdata[key]!;
//     }
//   }
//   return "";
// }
//   String myfunc(String selectedKey) {
//   for (var i = 0; i < mapdata.keys.length; i++) {
//     if (mapdata.keys.elementAt(i) == selectedKey) {
//       return mapdata[mapdata.keys.elementAt(i)]!;
//     }
//   }
//   return "";
// }

// String value = myfunc(selectedKey);

//  Icon(
//               Icons.favorite,
//               size: 50,
//               color: Colors.tealAccent,
//             ), - Иконки Like
//fit: FlexFit.loose - дополнительное пространство
//будет участвовать во flex
//Expanded - это fit, альтернативная запись

// class PlaceListBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: 100,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Список мест',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true, // перененос строки
//           overflow: TextOverflow.fade, // если softWrap неотработает
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }

// class MyMapBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: 110,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Карта',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true, // перененос строки
//           overflow: TextOverflow.fade, // если softWrap неотработает
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }

// class FavoriteBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: 110,
//       height: 50,
//       child: Center(
//         child: Text(
//           'Избранное',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true, // перененос строки
//           overflow: TextOverflow.fade, // если softWrap неотработает
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }
// Container(child: Row(...)) создает экземпляр класса
//Container, а в качестве значения свойства child этого
//экземпляра используется экземпляр класса Row. Это позволяет
//вложить один виджет внутрь другого, создавая иерархию
//виджетов для построения пользовательского интерфейса.
// child: Stack(
//           children: [
//             Container(
//               child: Image.asset(
//                 'lib/assets/images/mavzoley yasavi.jpg',
//                 fit: BoxFit.cover,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ],
