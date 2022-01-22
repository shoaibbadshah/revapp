// import 'package:avenride/ui/car/barcodescanner/barcodescanner_viewmodel.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/ui/car/barcodescanner/barcodescanner_viewmodel.dart';
import 'package:avenride/ui/car/searchingdriver/seacrhdriver_view.dart';
import 'package:avenride/ui/shared/constants.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flare_flutter/base/math/mat2d.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_io/io.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class BarCodeScannerView extends StatelessWidget {
  BarCodeScannerView({Key? key, required this.code}) : super(key: key);
  String code;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BarCodeScannerViewModel>.reactive(
      onModelReady: (model) {
        model.getData(code);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: model.isError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: screenWidth(context) / 16,
                        ),
                        child: Text(
                          'No Driver Found, try again!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      verticalSpaceRegular,
                      ElevatedButton(
                        onPressed: () {
                          model.navigationService.back();
                        },
                        child: Text('Go back'),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) / 18),
                    child: Column(
                      children: [
                        verticalSpaceLarge,
                        Center(
                          child: Container(
                            // height: 200,
                            // width: 200,
                            // decoration: BoxDecoration(
                            //   color: Colors.grey,
                            //   borderRadius: BorderRadius.circular(
                            //     30,
                            //   ),
                            // ),
                            padding: EdgeInsets.all(0.5),
                            child: GestureDetector(
                              onTap: () {
                                model.navigationService.navigateToView(
                                  DetailScreen(
                                    imgUrl: model.driver.photoUrl,
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Hero(
                                    tag: 'imageHero',
                                    child: Image.network(model.driver.photoUrl),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        verticalSpaceRegular,
                        Card(
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // width: screenWidth(context,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              children: [
                                verticalSpaceTiny,
                                Row(
                                  children: [
                                    Text(
                                      'Driver :',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model.driver.name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          child: Text(
                                            '6 months and more ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.green,
                                          ),
                                          child: Text(
                                            'Verified',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceSmall,
                                      ],
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model.driver.mobileNo,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            launch(
                                                "tel://${model.driver.mobileNo}");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.red,
                                            ),
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            ),
                                            // child: Text(
                                            //   'call',
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //     color: Colors.white,
                                            //     fontSize: 14,
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                        horizontalSpaceSmall,
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpaceRegular,
                        Card(
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // width: screenWidth(context,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              children: [
                                verticalSpaceTiny,
                                Row(
                                  children: [
                                    Text(
                                      'Car Details :',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.driver.carNumber,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      model.driver.carModel,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                    ),
                                    horizontalSpaceTiny,
                                    Text(
                                      model.driver.carColor,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpaceSmall,
                        RichText(
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text:
                                    'You are about to share or use drivers information detail(s) in line with our terms and conditions. Avenride  Multi-Systems Technologies LTD provides users this services, by clicking share you confirm that you have read, understood and accepted the Avenride Terms and conditions. Avenride Terms and conditions is in line with the Nigeria Data and Information Regulatory Act. Sharing of drivers details most be complaint with Avenride users policies. Please take the time to carefully read and understand the Avenride Terms and conditions before sharing drivers.',
                                style: new TextStyle(color: Colors.black),
                              ),
                              new TextSpan(
                                text: 'Read more...',
                                style: new TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://us-central1-unique-nuance-310113.cloudfunctions.net/policy');
                                  },
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceRegular,
                      ],
                    ),
                  ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                title: "Are you sure?",
                content: Text(
                  'By clicking Continue, you agree to all terms and condition!',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                buttons: <DialogButton>[
                  DialogButton(
                    color: Colors.blue,
                    child: Text("Not now"),
                    onPressed: () {
                      model.navigationService.back();
                    },
                  ),
                  DialogButton(
                    child: Text("Continue"),
                    onPressed: () {
                      Share.share(
                        'Driver Details: ${model.driver.name}, ${model.driver.mobileNo}, ${model.driver.photoUrl}, ${model.driver.carNumber}, ${model.driver.carModel}, ${model.driver.carColor}',
                      );
                      model.navigationService.back();
                    },
                  ),
                ],
              ).show();
            },
            child: Text('Share driver`s details'),
          ),
        ),
      ),
      viewModelBuilder: () => BarCodeScannerViewModel(),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey();
  bool isloading = false;
  final navigationService = locator<NavigationService>();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${(result!.format).toString()}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                    'Camera facing ${(snapshot.data!).toString()}');
                              } else {
                                return const Text('loading..');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      print('is loading $isloading');
      if (isloading == false) {
        setState(() {
          isloading = true;
        });
        if (scanData.code != null) {
          navigationService.replaceWithTransition(
            BarCodeScannerView(code: scanData.code!),
          );
          return;
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
