import 'package:avenride/services/distance.dart';
import 'package:avenride/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:avenride/app/app.router.dart';
import 'package:avenride/ui/BottomSheetUi/setup_bottom_sheet_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart';
import 'app/app.locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");
  setupLocator();
  setPathUrlStrategy();
  setupBottomSheetUi();
  final _pushservice = locator<PushNotificationService>();
  _pushservice.initializePushNotificationService();
  final _calculate = locator<Calculate>();
  await _calculate.getCurrentLocation();
  runApp(VxState(
    store: MyStore(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}

class MyStore extends VxStore {
  Map<String, dynamic> carride = {};
  String paymentMethod = 'Cash';
  String rideType = 'Personal Ride';
}

class Increment extends VxMutation<MyStore> {
  final Map<String, dynamic> carride;

  Increment(this.carride);
  @override
  perform() {
    store!.carride.addAll(carride);
  }
}

class ChangePaymentMethod extends VxMutation<MyStore> {
  final String method;
  final String ride;
  ChangePaymentMethod(this.method, this.ride);

  @override
  perform() {
    store!.paymentMethod = method;
    store!.rideType = ride;
  }
}
