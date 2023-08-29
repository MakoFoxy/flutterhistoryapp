// import 'dart:math';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mausoleum/videorepo/app_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_update/in_app_update.dart';
// import 'package:mausoleum/videorepo/utils/custom_colors.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   AppUpdateInfo? _updateInfo;

//   final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();

//   void _showSnack(String text) {
//     if (_scafoldKey.currentContext != null) {
//       ScaffoldMessenger.of(_scafoldKey.currentContext!).showSnackBar(
//         SnackBar(
//           content: Text(text),
//         ),
//       );
//     }
//   }

//   void initState() {
//     if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
//       InAppUpdate.performImmediateUpdate().catchError((e) {
//         _showSnack(e.toString());
//       });
//     } else {
//       Future.delayed(const Duration(seconds: 8), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const AppScreen(),
//           ),
//         );
//       });
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backGround,
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 20.w,
//             vertical: 20.h,
//           ),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Video',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 40,
//                       color: CustomColors.primary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     "Video Downloader",
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(
//                       fontSize: 35,
//                       color: CustomColors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'History Video',
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       color: CustomColors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     'History person',
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(
//                       fontSize: 25,
//                       color: CustomColors.primary,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         'multiple',
//                         textAlign: TextAlign.left,
//                         style: GoogleFonts.poppins(
//                           fontSize: 25,
//                           color: CustomColors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         'history bio',
//                         textAlign: TextAlign.left,
//                         style: GoogleFonts.poppins(
//                           fontSize: 25,
//                           color: CustomColors.primary,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   Text(
//                     'Video Downloader!',
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       color: CustomColors.white,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
