// import 'package:flutter/material.dart';

// void main() {
//   DataName myDataName = DataName();
//   Overview myover = Overview();
//   print(myover.mapdatas);
// }

// class Overview {
//   late List<String> title = [];
//   late List<String> mythem = [];
//   late List<String> arrthems = [];
//   late List<String> person = [];
//   late List<String> personbio = [];
//   late List<String> arrpersonname = [
//     "Ходжа Ахмед Ясави",
//     "Арыстан-Баб",
//     "Есим хан",
//     "Тауке хан",
//     "Деятель",
//   ];
//   late Map<String, String> mapdataname = {};
//   late Map<String, String> mapdatas = {};
//   List<Map<String, String>> result = [];

//   Overview() {
//     this.title = title;
//     this.mythem = mythem;
//     this.person = person;
//     this.arrthems = arrthems;
//     this.personbio = personbio;
//     this.mapdataname = mapdataname;
//     this.mapdatas = mapdatas;
//     this.result = result;

//     arrpersonname = [
//       "Ходжа Ахмед Ясави",
//       "Арыстан-Баб",
//       "Есим Хан",
//       "Тауке Хан",
//       "Казыбек-Би",
//     ];

//     for (int i = 0; i < arrpersonname.length; i++) {
//       person.add(arrpersonname[i]);
//     }

//     arrthems = [
//       "Мавзолей Ходжи Ахмеда Ясави (каз. Қожа Ахмет Яссауи кесенесі) — мавзолей на могиле тюркского поэта и основателя суфийского ордена Яссавия Ходжи Ахмеда Ясави, расположенный в городе Туркестане в Туркестанской области Казахстана. Является центральным объектом на территории историко-культурного музея-заповедника «Хазрет-султан».",
//       "Арыста́н-Баб или Арсла́н-Баб (каз. Арыстанбаб, кирг. Арстанбап, узб. Arslonbob) — среднеазиатский святой. По одной из легенд, потомок имама Мухаммада ибн аль-Ханафии, родной дядя и первый учитель Ходжи Ахмеда Ясави. Согласно другой легенде, долгожитель, сподвижник пророка Мухаммеда, выполнивший указание (аманат) пророка в отношении Ясави[⇨]. Мавзолей расположен 60 км от Туркестана и является местом паломничества.",
//       "Есим-хан (1565—1628) (каз. Есім хан) — хан Казахского ханства в 1598—1628 годах, являлся сыном Шигай-хана и Яхшим-бигим Ханым. После смерти брата Тауекель-хана султан Есим становится ханом Казахского ханства во время похода на Бухару Есим-хан получил в народе прозвище (Отважный Есим Великан) за отвагу в отражении внешней агрессии на Казахское ханство. Его правление стало временем очередного усиления Казахского ханства, третьим по счету после Касым-хана и Хак-Назар-хана. Есим-хан переносит столицу ханства из Сыгнака в Туркестан",
//       "Таввакул-Мухаммад-Бахадур-хан Гази, Тауке-хан, Аз Тауке-хан, Азиз Тауке. (каз. Тәуке хан) (годы правления 1680—1715) — хан Казахского ханства с 1680 года. Сын Салкам-Жангира, внук Есим-хана. Автор свода законов «Жеты Жаргы» вместе с Триумвиратом - Толе би, Казыбек би, и Айтеке би",
//       "Казыбек «Каз Дауысты» Кельдибекулы[1] (каз. Қазыбек «Қаз Дауысты» Келдібекұлы, 1667, прибрежья Сырдарьи — 1763 (по другим данным, 1764 и 1765[2]), зимовка у ключа Теракты в современном Каркаралинском районе Карагандинской области Казахстана[2]) — великий казахский бий, великий оратор, общественный деятель и посол."
//     ];
//     arrthems.forEach((infoverview) {
//       personbio.add(infoverview);
//     });

//     title = [];
//     mythem = [];
//     if (person.length == personbio.length) {
//       for (int i = 0; i < person.length; i++) {
//         title.add(person[i]);
//       }
//       for (int j = 0; j < personbio.length; j++) {
//         mythem.add(personbio[j]);
//       }
//     } else {
//       print('ERROR:length of array is not correct');
//     }
//     print("title $title");
//     print("mythem $mythem");
//     print("person $person");
//     print("personbio $personbio");
//     print("mapdatas $mapdatas");
//     print("mapdataname $mapdataname");

//     mapdataname = myoverview();
//     mapdataname.forEach((key, value) {
//       // Делайте с каждой парой ключ-значение
//       mapdatas[key] = value;
//     });

//     mapdatas.forEach((key, value) {
//       result.add({key: value});
//     });
//     print("mapdatas2 $mapdatas");
//     print("mapdataname2 $mapdataname");
//     print("result $result");
//   }

//   Map<String, String> myoverview() {
//     Map<String, String> mapdataname = {};
//     for (int i = 0; i < title.length; i++) {
//       if (title.length == mythem.length) {
//         mapdataname['${title[i]}'] = '${mythem[i]}';
//       }
//     }
//     return mapdataname;
//   }
// }

// class DataName {
//   late String element;
//   late int index;
//   late String indexname;
//   late List<String> arrpersonname;
//   late List<String> resname;
//   DataName() {
//     element = "";
//     resname = [];
//     arrpersonname = [
//       "Ходжа Ахмед Ясави",
//       "Арыстан-Баб",
//       "Есим хан",
//       "Тауке хан",
//       "Деятель",
//     ];

//     arrpersonname.forEach((element) {
//       if (element == "Ходжа Ахмед Ясави" ||
//           element == "Арыстан-Баб" ||
//           element == "Есим хан" ||
//           element == "Тауке хан" ||
//           element == "Деятель") {
//         resname.add(element);
//       }
//     });
//     index = indexIterable(element, resname);
//     indexname = indexName(index, resname);
//   }
// }

// int indexIterable(String element, List<String> resname) {
//   int index = 0;
//   for (int i = 0; i < resname.length; i++) {
//     if (resname[i] == element) {
//       index = i;
//     }
//   }
//   return index;
// }

// String indexName(int index, List<String> resname) {
//   if (index >= 0 && index < resname.length) {
//     return resname[index];
//   } else {
//     return "";
//   }
// }


// class OverviewData {
//   final data = [
//     Overview(
//       title: '';
//     );
//   ];
// }
