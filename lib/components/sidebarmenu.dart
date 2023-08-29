// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mausoleum/pages/homepage.dart';
// import 'package:rive/rive.dart';
// import 'package:gif_view/gif_view.dart';
// import 'package:mausoleum/components/sidemenutile.dart';

// class assetInteractive {
//   late String artboard;
//   late String page;
//   //late String stateMachineName;

//   late SMIBool? input;

//   assetInteractive({
//     required this.artboard,
//     // required this.stateMachineName,
//     required this.page,
//     this.input,
//   });

//   set setInput(SMIBool status) {
//     input = status;
//   }
// }

// List<assetInteractive> arrassetInteractive = [
//   assetInteractive(
//     artboard: "lib/assets/images/icons-homepage.jpg",
//     page: "Негізгі бет",
//   ),
//   assetInteractive(
//     artboard: "lib/assets/images/free-icon-link.png",
//     page: "Бөлісу",
//   ),
//   assetInteractive(
//     artboard: "lib/assets/images/icons-star.png",
//     page: "Қолданбаны бағалаңыз",
//   ),
//   assetInteractive(
//     artboard: "lib/assets/images/icons-messages.png",
//     page: "Әзірлеушілерге жазыңыз",
//   ),
//   assetInteractive(
//     artboard: "lib/assets/images/icons-map.png",
//     page: "Картадағы объектілердің орналасуы",
//   ),
//   assetInteractive(
//     artboard: "lib/assets/images/icons-contacts.png",
//     page: "Контактілер",
//   ),
// ];

// class SideMenu extends StatefulWidget {
//   const SideMenu({super.key});

//   @override
//   State<SideMenu> createState() => _SideMenuState();
// }

// class _SideMenuState extends State<SideMenu> {
//   assetInteractive selectedMenus = arrassetInteractive.first;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: 288,
//           height: double.infinity,
//           color: const Color.fromARGB(255, 96, 139, 125),
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const InfoCard(
//                   name: "Snynbo",
//                   profession: "Software Eng.",
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
//                   child: Text(
//                     "Көздеу".toUpperCase(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium!
//                         .copyWith(color: Colors.white70),
//                   ),
//                 ),
//                 ...arrassetInteractive.map(
//                   (menu) => SideMenuTile(
//                     menu: menu,
//                     press: () {
//                       menu.input!.change(true);
//                       Future.delayed(
//                         const Duration(seconds: 1),
//                         () {
//                           menu.input!.change(false);
//                         },
//                       );
//                       setState(() {
//                         selectedMenus = menu;
//                       });
//                     },
//                     isActive: selectedMenus == menu,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InfoCard extends StatelessWidget {
//   const InfoCard({
//     Key? key,
//     required this.name,
//     required this.profession,
//   }) : super(key: key);

//   final String name, profession;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const CircleAvatar(
//         backgroundColor: Colors.grey,
//         child: Icon(
//           CupertinoIcons.person,
//           color: Colors.white,
//         ),
//       ),
//       title: Text(
//         name,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//       subtitle: Text(
//         profession,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
