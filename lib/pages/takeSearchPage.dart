// import 'dart:io';
// import 'package:mausoleum/models/overview.dart';
// import 'package:flutter/material.dart';
// import 'package:mausoleum/models/overview.dart';
// import 'package:mausoleum/models/generalwidgets.dart';
// import 'package:mausoleum/models/createpost/createpostscree.dart';
// import 'package:mausoleum/pages/homepage.dart';
// import 'package:mausoleum/objectpage.dart';
// import 'package:todo_repo/todo_repo.dart';
// import 'package:mausoleum/pages/editPages.dart';
// import 'package:todo_models/todo_model.dart';
// import 'package:todo_services/data_models/dbtodo.dart';
// import 'package:mausoleum/models/generalwidgets.dart';

// class takeSearchPage extends StatefulWidget {
//   List<TodoModel> resList;
//   //TodoModel resModel;

//   takeSearchPage({required this.resList});
//   // takeSearchPage({required this.resModel, required this.resList});

//   @override
//   //State<takeSearchPage> createState() => ApptakeSearchPage(resulterList: resulterList);
//   // State<takeSearchPage> createState() => ApptakeSearchPage();
//   State<takeSearchPage> createState() => ApptakeSearchPage(resList: resList);
// }

// class ApptakeSearchPage extends State<takeSearchPage> {
//   String imageUrl = 'lib/assets/images/backgroundImages.jpg';
//   List<TodoModel> resList; // Добавьте это объявление
//   //  ApptakeSearchPage({required this.resulterList});
//   // TodoModel resModel; // Добавьте это объявление
//   ApptakeSearchPage({required this.resList});

//   @override
//   final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: DefaultTextStyle.merge(
//           style: whiteTexstStyle,
//           child: Container(
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white, // Цвет подсветки
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.only(left: 0, right: 0),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: takeCheckPage(
//                       resList: resList,
//                       backgroundImage: DecorationImage(
//                         image: AssetImage(imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   //height: 118,
//                   padding: const EdgeInsets.all(0),
//                   child: MenuTile(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class takeCheckPage extends StatefulWidget {
//   List<TodoModel> resList; // Добавьте это поле
//   // TodoModel resModel; // Добавьте это поле

//   final DecorationImage backgroundImage;
//   // takeCheckPage(
//   //     {required this.resulterList, required this.backgroundImage, Key? key})
//   //     : super(key: key);
//   // MyHomePage({required this.backgroundImage, Key? key}) : super(key: key);

//   takeCheckPage(
//       {required this.resList, required this.backgroundImage, Key? key})
//       : super(key: key);

//   @override
// //  takeCheckPageState createState() =>
// //       takeCheckPageState(resulterList: resulterList);  //takeCheckPage createState() => takeCheckPageState();
//   takeCheckPageState createState() => takeCheckPageState(resList: resList);
// }

// TextEditingController keyword = TextEditingController();

// class takeCheckPageState extends State<takeCheckPage> {
//   List<TodoModel> resList;
//   takeCheckPageState({required this.resList});

//   @override
//   void initState() {
//     super.initState();
//     resList = resList;
//   }

//   Future<void> keywordAsyncFunction(String keyword) async {
//     print("selectedKey1 $keyword");
//     resList.clear();
//     Future<List<TodoModel>> myres = TodoRepository().searchDB(keyword);
//     List<TodoModel> myresList = await myres; // Дождитесь завершения Future
//     for (int i = 0; i < myresList.length; i++) {
//       if (myresList[i].title == keyword && !resList.contains(myresList[i])) {
//         resList.add(myresList[i]);
//       }
//     }
//   }

//   @override
//   final whiteTexstStyle = TextStyle(color: Colors.white, fontSize: 24);

//   @override
//   Widget build(BuildContext context) {
//     final colorTextStyle = TextStyle(
//       color: Color.fromARGB(255, 78, 82, 26),
//       fontSize: 25,
//     ); // Обновленный размер текста
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('lib/assets/images/backgroundImages.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: FutureBuilder(
//             future: keyword.text.length > 0
//                 ? Future.value([])
//                 : Future.value([]),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasError) {
//                 // Обработка ошибок при загрузке данных.
//                 return Text("Ошибка при загрузке данных");
//               } else if (!snapshot.hasData) {
//                 return Text("Нет данных");
//               } else {
//                 // Данные успешно загружены, отображаем их.
//                 //List<TodoModel> data = snapshot.data as List<TodoModel>;
//                 // TodoModel resModel = snapshot.data as TodoModel;
//                 return Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Center(
//                         child: TextField(
//                           controller: keyword,
//                           onSubmitted: (value) {
//                             setState(() {
//                               // ignore: unrelated_type_equality_checks
//                               keyword.text = value;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             prefixIcon: IconButton(
//                               icon: const Icon(Icons.search),
//                               onPressed: () {
//                                 if (keyword.text == '') {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => HomePage(),
//                                     ),
//                                   );
//                                 }
//                                 setState(() {
//                                   keywordAsyncFunction(keyword.text);
//                                 });
//                               },
//                             ),
//                             suffixIcon: IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 keyword.text = '';
//                               },
//                             ),
//                             hintText: 'Іздеу...',
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color.fromARGB(255, 134, 133, 45),
//                             blurRadius: 40,
//                             offset: Offset(1, 1),
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(30),
//                         gradient: LinearGradient(colors: [
//                           Color.fromARGB(255, 187, 185, 60),
//                           Color.fromARGB(235, 233, 229, 16),
//                           Color.fromARGB(255, 187, 185, 60),
//                         ]),
//                       ),
//                       child: Text(
//                         'Мавзолей',
//                         textAlign: TextAlign.center,
//                         style: colorTextStyle,
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.separated(
//                         itemCount: resList.length,
//                         separatorBuilder: (context, index) =>
//                             SizedBox(height: 10),
//                         itemBuilder: (context, index) {
//                           return Container(
//                             margin: const EdgeInsets.only(left: 50, right: 50),
//                             padding: const EdgeInsets.symmetric(vertical: 5),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Обработчик нажатия кнопки с ключом
//                                 print('Нажата кнопка с ключом: $resList');
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ObjectPage(
//                                         selectedId: resList[index].letId,
//                                         selectedKey: resList[index].title),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 primary: Colors.amber.withOpacity(0.8),
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                   horizontal: 30,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               child: Text(
//                                 resList[index].title,
//                                 //  ? data[index].title
//                                 // : widget.resulterList[index].title,
//                                 style: colorTextStyle,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: Stack(
//         children: [
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: FloatingActionButton(
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateHistoryPost(),
//                   ),
//                 );
//               },
//               child: const Icon(Icons.create),
//             ),
//           ),
//           Positioned(
//   left: 20,
//   bottom: 0,
//   child: FloatingActionButton(
//     onPressed: () async {
//       await TodoRepository().deleteAlltables();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     },
//     child: const Icon(Icons.delete),
//   ),
// ),
//         ],
//       ),
//     );
//   }
// }

// class MenuTile extends StatefulWidget {
//   @override
//   MenuTileWidget createState() => MenuTileWidget();
// }

// class MenuTileWidget extends State<MenuTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         // padding: const EdgeInsets.only(left: 0, right: 0),
//         child: Column(
//           children: <Widget>[
//             Container(
//               color: Colors.amber[500],
//               margin: const EdgeInsets.all(0),
//               child: _buildRating(),
//             ),
//             SizedBox(height: 0),
//             Card(
//               elevation: 5,
//               margin: const EdgeInsets.all(0),
//               child: Container(
//                 color: Colors.amber,
//                 padding: const EdgeInsets.all(10),
//                 child: _buildAction(),
//               ),
//             ),
//           ],
//         ),
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 231, 177, 15),
//           border: Border.all(),
//         ),
//       ),
//     );
//   }

//   Widget _buildRating() => ListTile(
//         title: Text(
//           'Добавить в избранное',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 16.0,
//           ),
//         ),
//         // subtitle: Text('Выбирите небходимый раздел'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             FavoriteWidjet(),
//           ],
//         ),
//       );

//   Widget _buildAction() => Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           _buildButton("Меню", Icons.menu, Colors.transparent),
//           _buildButton("Карта", Icons.map, Colors.transparent),
//           _buildButton("Избранное", Icons.favorite, Colors.transparent),
//         ],
//       );

//   Widget _buildButton(
//     String label,
//     IconData icon,
//     Color color,
//   ) =>
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(
//             icon,
//             color: Colors.brown,
//           ),
//           Container(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w400,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       );
// }

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


// class SearchCheck extends StatefulWidget {
//   late TextEditingController keyword;

//   SearchCheck(this.keyword);

//   @override
//   State<SearchCheck> createState() => _searchCheckState();
// }

// class _searchCheckState extends State<SearchCheck> {
//   late TextEditingController keyword;

//   @override
//   void initState() {
//     super.initState();
//     keyword = widget.keyword; // Инициализируем контроллер в initState
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Center(
//         child: TextField(
//           controller: keyword,
//           onSubmitted: (value) async {
//             List<TodoModel> searchResults =
//                 await TodoRepository().searchDB(keyword.text);
//             setState(() {
//               // Обновляем состояние с результатами поиска
//               // Например, можно сохранить результаты в переменной и использовать их в UI
//               // searchResultsList = searchResults;
//             });
//           },
//           decoration: InputDecoration(
//             prefixIcon: IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () {
//                 // Удалите этот вызов
//               },
//             ),
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 setState(() {
//                   keyword.text = '';
//                 });
//               },
//             ),
//             hintText: 'Search...',
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
// }




























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



  // void clearState() => setState(() {
  //       _HomeIndex = 0;
  //       _HomeResultIndex = 0;
  //       _icons = [];
  //     });

  // void _onChangeStatus(bool _choiceFavor) {
  //   setState(() {
  //     if (_choiceFavor == true) {
  //       _icons.add(
  //         Icon(Icons.brightness_1, color: Colors.amber),
  //       );
  //       _HomeIndex++;
  //     } else {
  //       _icons.add(
  //         Icon(Icons.brightness_1, color: Colors.black),
  //       );
  //     }

  //     _HomeResultIndex = _HomeResultIndex + 1;
  //   });
  // }


 // Expanded(
            //   flex: 1, // MenuTile будет занимать в один раз меньше пространства
            //   child: MenuTile(),
            // ),
            // Expanded(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Expanded(
            //         flex: 2,
            //         child: MyHomePage(),
            //       ),
            //     ],
            //   ),
            // ),

            // Expanded(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Expanded(
            //         flex: 1,
            //         child: MenuTile(),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   height: 50,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Flexible(
            //         fit: FlexFit.tight,
            //         flex: 1,
            //         child: PlaceListBox(),
            //       ),
            //       Flexible(
            //         fit: FlexFit.tight,
            //         flex: 1,
            //         child: MyMapBox(),
            //       ),
            //       Flexible(
            //         fit: FlexFit.tight,
            //         flex: 1,
            //         child: FavoriteBox(),
            //       ),
            //     ],
            //   ),
            // ),

// class PlaceListBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       child: Center(
//         child: Text(
//           'Список мест',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true,
//           overflow: TextOverflow.fade,
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
//       height: 50,
//       child: Center(
//         child: Text(
//           'Карта',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true,
//           overflow: TextOverflow.fade,
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
//       height: 50,
//       child: Center(
//         child: Text(
//           'Избранное',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//           softWrap: true,
//           overflow: TextOverflow.fade,
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 124, 108, 59),
//         border: Border.all(),
//       ),
//     );
//   }
// }



// class MyRatingWidjet extends StatelessWidget {
//   Widget _buildRating() => ListTile(
//         title: Text(
//           'Меню',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         subtitle: Text('Выбирите небходимый раздел'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             MyRowColumnMain(),
//           ],
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return _buildRating();
//   }
// }

// class MyRatingWidjet0 extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: 350,
//       child: Card(
//         margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//         elevation: 5,
//       ),
//     );
//   }
// }