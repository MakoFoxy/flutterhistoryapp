// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:share_plus/share_plus.dart';

// class FirestoreServices {
//   Future<List<DocumentSnapshot>> getInfofirestore(
//       String pathCollection, int limit, String textSearch) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//     List<DocumentSnapshot> result = [];
//     QuerySnapshot? response;
//     if (textSearch.isNotEmpty) {
//       response = await firebaseFirestore
//           .collection(pathCollection)
//           .limit(limit)
//           .get();

//       result = response.docs;
//     } else {
//       response =
//           await firebaseFirestore.collection(pathCollection).limit(limit).get();
//       result = response.docs;
//     }
//     return result;
//   }
// }
