// import 'package:flutter/material.dart';
// import 'package:mausoleum/components/sidebarmenu.dart';
// import 'package:rive/rive.dart';

// class SideMenuTile extends StatelessWidget {
//   final assetInteractive menu;
//   final VoidCallback press;
//   //final ValueChanged<Artboard> riveonInit;
//   final bool isActive;
//   SideMenuTile({
//     Key? key,
//     required this.menu,
//     required this.press,
//     // required this.riveonInit,
//     required this.isActive,
//   }) : super(
//           key: key,
//         );

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 24),
//           child: Divider(
//             color: Colors.white24,
//             height: 1,
//           ),
//         ),
//         Stack(
//           children: [
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.fastOutSlowIn,
//               height: 56,
//               width: isActive ? 288 : 0,
//               left: 0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.blueGrey,
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//             ListTile(
//               onTap: press,
//               leading: SizedBox(
//                 height: 34,
//                 width: 34,
//                 child: Image.asset(menu.artboard),
//               ),
//               title: Text(menu.page,
//                   style: TextStyle(
//                     color: Colors.white,
//                   )),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
