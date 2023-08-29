import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mausoleum/qrscanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mausoleum/pages/qrobjectpage.dart';

class ResultScreen extends StatelessWidget {
  final String code;

  final Function() closeScreen;

  const ResultScreen(
      {super.key, required this.closeScreen, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            closeScreen();
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
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: code,
              size: 150,
              version: QrVersions.auto,
            ),
            Text(
              "Scanned result",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              code,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  //Clipboard.setData(ClipboardData(text: code));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRobjectpage(
                        selectedKey: code,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Copy",
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
