import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mausoleum/pages/qroverlay.dart';
import 'package:mausoleum/pages/qrobjectpage.dart';
import 'package:easy_localization/easy_localization.dart';

const bgColor = Colors.white;

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String selectedKey = '';
  bool isScanComplated = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  MobileScannerController controller = MobileScannerController();

  // void closeScreen() {
  //   isScanComplated = false;
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "use QR code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double
                  .infinity, // Установите ширину по максимальной доступной ширине
              height: MediaQuery.of(context).size.height - 310,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical:
                            0), // Установите необходимые значения отступов
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              16.0), // Здесь устанавливаем радиус скругления углов
                          border: Border.all(
                            color: Colors.white, // Цвет рамки
                            width: 2.0, // Ширина рамки
                          ),
                        ),
                        child: MobileScanner(
                          controller: MobileScannerController(
                            detectionSpeed: DetectionSpeed.normal,
                            facing: CameraFacing.back,
                            torchEnabled: false,
                            autoStart: true,
                          ),
                          onDetect: (capture) {
                            //closeScreen();
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              if (isScanComplated == false &&
                                  selectedKey != barcode.rawValue) {
                                selectedKey = barcode.rawValue ?? '---';
                                isScanComplated = true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QRobjectpage(selectedKey: selectedKey),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const QRScannerOverlay(overlayColour: bgColor),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Developed version 1.0",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
