import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mausoleum/pages/firebaseobjectpage.dart';
import 'package:just_audio/just_audio.dart';

class DropdownFlag extends StatefulWidget {
  String selectedKey;

  DropdownFlag({
    super.key,
    required this.changedLanguage,
    required this.selectedKey,
  });

  final ValueChanged<String> changedLanguage;

  @override
  State<DropdownFlag> createState() => DropdawnFlagState();
}

class DropdawnFlagState extends State<DropdownFlag> {
  String dropdownValue = "";

  @override
  void didUpdateWidget(covariant DropdownFlag oldWidget) {
    dropdownValue = context.locale.languageCode;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    dropdownValue = context.locale.languageCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Row(
          children: [
            Text(dropdownValue),
            const SizedBox(
              width: 5,
            ),
            Image.asset('lib/assets/images/$dropdownValue.png'),
          ],
        ),
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 90,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownStyleData: const DropdownStyleData(
          width: 90,
        ),
        underline: const SizedBox(),
        items: List.generate(context.supportedLocales.length, (index) {
          return DropdownMenuItem<String>(
            onTap: () {
              setState(() {
                dropdownValue = context.supportedLocales[index].languageCode;
                widget.changedLanguage(dropdownValue);
              });
              Navigator.push( 
                context,
                MaterialPageRoute(
                  builder: (context) {
                    //_audioPlayer.stop();
                    return ObjectFirebasePage(
                      selectedKey: widget.selectedKey,
                    );
                  },
                ),
              );
              //_audioPlayer.stop();
            },
            value: context.supportedLocales[index].languageCode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  context.supportedLocales[index].languageCode,
                ),
                SizedBox(
                  width: 12,
                ),
                Image.asset(
                  'lib/assets/images/${context.supportedLocales[index].languageCode}.png',
                  width: 30,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}

class DropdownFlagHome extends StatefulWidget {
  DropdownFlagHome({
    super.key,
    required this.changedLanguage,
  });

  final ValueChanged<String> changedLanguage;

  @override
  State<DropdownFlagHome> createState() => DropdownFlagHomeState();
}

class DropdownFlagHomeState extends State<DropdownFlagHome> {
  String dropdownValue = "";

  @override
  void didUpdateWidget(covariant DropdownFlagHome oldWidget) {
    dropdownValue = context.locale.languageCode;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    dropdownValue = context.locale.languageCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Row(
          children: [
            Text(dropdownValue),
            const SizedBox(
              width: 5,
            ),
            Image.asset('lib/assets/images/$dropdownValue.png'),
          ],
        ),
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 90,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownStyleData: const DropdownStyleData(
          width: 90,
        ),
        underline: const SizedBox(),
        items: List.generate(context.supportedLocales.length, (index) {
          return DropdownMenuItem<String>(
            onTap: () {
              setState(() {
                dropdownValue = context.supportedLocales[index].languageCode;
                widget.changedLanguage(dropdownValue);
              });
            },
            value: context.supportedLocales[index].languageCode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  context.supportedLocales[index].languageCode,
                ),
                SizedBox(
                  width: 12,
                ),
                Image.asset(
                  'lib/assets/images/${context.supportedLocales[index].languageCode}.png',
                  width: 30,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}



// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DropdawnFlag extends StatefulWidget {
//   const DropdawnFlag({
//     Key? key,
//     required this.changedLanguage,
//     required this.selectedKey,
//   }) : super(key: key);

//   final ValueChanged<String> changedLanguage;
//   final String selectedKey;

//   @override
//   State<DropdawnFlag> createState() => DropdawnFlagState();
// }

// class DropdawnFlagState extends State<DropdawnFlag> {
//   String dropdownValue = "";

//   @override
//   void initState() {
//     super.initState();
//     // Используем widget.selectedKey для установки начального значения dropdownValue
//     determineLanguageCode(widget.selectedKey).then((languageCode) {
//       setState(() {
//         dropdownValue = languageCode;
//       });
//     });
//   }
 
//   // Функция, вызываемая при обновлении виджета
//   @override
//   void didUpdateWidget(covariant DropdawnFlag oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Проверяем, изменился ли выбранный ключ
//     if (oldWidget.selectedKey != widget.selectedKey) {
//       // Если да, обновляем dropdownValue с использованием нового ключа
//       determineLanguageCode(widget.selectedKey).then((languageCode) {
//         setState(() {
//           dropdownValue = languageCode;
//         });
//       });
//     }
//   }
//  @override
//   void didChangeDependencies() {
//     dropdownValue = context.locale.languageCode;
//     super.didChangeDependencies();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         customButton: Row(
//           children: [
//             Text(dropdownValue),
//             const SizedBox(
//               width: 12,
//             ),
//             Image.asset('lib/assets/images/$dropdownValue.png'),
//           ],
//         ),
//         buttonStyleData: const ButtonStyleData(
//           height: 40,
//           width: 90,
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 40,
//         ),
//         dropdownStyleData: const DropdownStyleData(
//           width: 90,
//         ),
//         underline: const SizedBox(),
//         items: List.generate(context.supportedLocales.length, (index) {
//           final languageCode = context.supportedLocales[index].languageCode;
//           return DropdownMenuItem<String>(
//             onTap: () async {
//               final newLocale =
//                   await determineLocale(widget.selectedKey, languageCode);
//               setState(() {
//                 dropdownValue = languageCode;
//                 context.setLocale(newLocale);
//                 widget.changedLanguage(languageCode);
//               });
//             },
//             value: languageCode,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(languageCode),
//                 SizedBox(
//                   width: 12,
//                 ),
//                 Image.asset(
//                   'lib/assets/images/$languageCode.png',
//                   width: 30,
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         onChanged: (value) {},
//       ),
//     );
//   }

//   // Функция для определения кода языка на основе ключа
//   Future<String> determineLanguageCode(String selectedKey) async {
//     // Получаем данные из Firestore на основе выбранного ключа и возвращаем соответствующий код языка
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebasekz;
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseru;
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>? datafirebaseen;
//     late QuerySnapshot<Map<String, dynamic>> datakz;
//     late QuerySnapshot<Map<String, dynamic>> dataru;
//     late QuerySnapshot<Map<String, dynamic>> dataen;
//     dataru = await FirebaseFirestore.instance.collection('dataru').get();
//     datakz = await FirebaseFirestore.instance.collection('datakz').get();
//     dataen = await FirebaseFirestore.instance.collection('dataen').get();

//     datafirebasekz = datakz.docs.toList();
//     datafirebaseru = dataru.docs.toList();
//     datafirebaseen = dataen.docs.toList();

//     late String languages = "";

//     for (int i = 0; i < datafirebasekz.length; i++) {
//       if (widget.selectedKey == datafirebasekz[i]['title']) {
//         languages = "kk";
//         break;
//       }
//     }
//     for (int i = 0; i < datafirebaseru.length; i++) {
//       if (widget.selectedKey == datafirebaseru[i]['title']) {
//         languages = "ru";
//         break;
//       }
//     }
//     for (int i = 0; i < datafirebaseen.length; i++) {
//       if (widget.selectedKey == datafirebaseen[i]['title']) {
//         languages = "en";
//         break;
//       }
//     }
//     return languages;
//   }

//   // Функция для определения локали на основе ключа и кода языка
//   Future<Locale> determineLocale(
//       String selectedKey, String languageCode) async {
//     // Получаем данные из Firestore на основе выбранного ключа и кода языка, а затем возвращаем соответствующую локаль
//     var datafirebasekz;
//     var datafirebaseru;
//     var datafirebaseen;
//     final dataru = await FirebaseFirestore.instance.collection('dataru').get();
//     final datakz = await FirebaseFirestore.instance.collection('datakz').get();
//     final dataen = await FirebaseFirestore.instance.collection('dataen').get();
//     datafirebasekz = datakz.docs.toList();
//     datafirebaseru = dataru.docs.toList();
//     datafirebaseen = dataen.docs.toList();

//     for (int i = 0; i < datafirebasekz.length; i++) {
//       if (widget.selectedKey == datafirebasekz[i]['title']) {
//         return Locale(languageCode, 'KK');
//       }
//     }
//     for (int i = 0; i < datafirebaseru.length; i++) {
//       if (widget.selectedKey == datafirebaseru[i]['title']) {
//         return Locale(languageCode, 'RU');
//       }
//     }
//     for (int i = 0; i < datafirebaseen.length; i++) {
//       if (widget.selectedKey == datafirebaseen[i]['title']) {
//         return Locale(languageCode, 'EN');
//       }
//     }
//     return Locale(languageCode);
//   }
// }
