import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Assets {
  static String _imagesRoot = "assets/images/";
  static String firebase = _imagesRoot + "firebase.png";
  static String bgimg = _imagesRoot + "bgimg.png";
  static String btnbgimg = _imagesRoot + "btnbg.png";
  static String loadinimg = _imagesRoot + "loading.jpg";
  static String doneimg = _imagesRoot + "close.png";
  static String bananaBoat = _imagesRoot + "banana.png";
  static String ambulance = _imagesRoot + "ambulance.png";

  static String cargo6 = _imagesRoot + "cargo6.PNG";
  static String cargo5 = _imagesRoot + "cargo5.PNG";
  static String cargo4 = _imagesRoot + "cargo4.PNG";
  static String cargo3 = _imagesRoot + "cargo3.PNG";
  static String cargo2 = _imagesRoot + "cargo2.PNG";
  static String cargo1 = _imagesRoot + "cargo1.PNG";

  static String ride1 = _imagesRoot + "ride1.PNG";
  static String ride2 = _imagesRoot + "ride2.PNG";
  static String ride3 = _imagesRoot + "ride3.PNG";

  static String car1 = _imagesRoot + "car4.PNG";
  static String car2 = _imagesRoot + "car5.PNG";
  static String car3 = _imagesRoot + "car6.PNG";
  static String car4 = _imagesRoot + "car1.PNG";
  static String car5 = _imagesRoot + "car2.PNG";
  static String car6 = _imagesRoot + "car3.PNG";
  static String carlogo = _imagesRoot + "carlogo.PNG";
  static String taxilogo = _imagesRoot + "taxi.jpg";
  static String deliverylogo = _imagesRoot + "delivery.jpg";

  static String boat1 = _imagesRoot + "ogaride.PNG";
  static String boat2 = _imagesRoot + "familyride.PNG";
  static String boat3 = _imagesRoot + "picnictour.PNG";
  static String boat4 = _imagesRoot + "flixiride.PNG";
  static String boat5 = _imagesRoot + "banana.png";
  static String boat6 = _imagesRoot + "charterservice.PNG";

  static String getPaymentLink =
      'https://us-central1-unique-nuance-310113.cloudfunctions.net/getPaymentLink';

  static const double fourBy1 = 4.0;
  static const double fourBy2 = 8.0;
  static const double fourBy3 = 12.0;
  static const double fourBy4 = 16.0;

  static const double eightBy1 = 8.0;
  static const double eightBy2 = 16.0;
  static const double eightBy3 = 24.0;
  static const double eightBy4 = 32.0;

  static const double sixteenBy1 = 16.0;
  static const double sixteenBy2 = 32.0;
  static const double sixteenBy3 = 48.0;
  static const double sixteenBy4 = 64.0;
}

LatLng MMIA = LatLng(6.58250061471477, 3.320877305255524);
LatLng Abj = LatLng(9.009739944779172, 7.269213318952354);
LatLng PH = LatLng(5.015331700522605, 6.95408079731267);

List<NameIMG> carTypes = [
  NameIMG('AVR', Assets.carlogo, '100.0'),
  NameIMG('AVRX', Assets.carlogo, '200.0'),
  NameIMG('AVRXL', Assets.carlogo, '300.0'),
  NameIMG("AVR EXEC", Assets.carlogo, '400.0'),
];

class NameIMG {
  final String name;
  final String imagePath;
  final String price;
  NameIMG(this.name, this.imagePath, this.price);
}

List<NameIMG> boatTypes = [
  NameIMG('AV Boat 75', Assets.boat1, '200.0'),
  NameIMG('AV Boat Lekki 90', Assets.boat1, '300.0'),
  NameIMG('AV Boat Cover', Assets.boat1, '400.0'),
  NameIMG('AV Boat EXL 150', Assets.boat1, '500.0'),
];

List<NameIMG> cargoboatTypes = [
  NameIMG('AV Cargo Eko 75', Assets.cargo5, '100.0'),
  NameIMG('AV Cargo Eko West 150', Assets.cargo5, '200.0'),
  NameIMG('AV Cargo Lekki 90', Assets.cargo5, '300.0'),
  NameIMG('AV Cargo 115', Assets.cargo5, '500.0'),
];

List<NameIMG> deliveryTypes = [
  NameIMG('Motorcycle', Assets.ride1, '200.0'),
  NameIMG('Pick Up Van', Assets.ride2, '300.0'),
  NameIMG('Truck', Assets.ride3, '400.0'),
];
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
    ),
  ),
);

class WaterLoc {
  final String loc;
  final double latd;
  final double long;
  WaterLoc({required this.loc, required this.latd, required this.long});
}

List<WaterLoc> boatLoc = [
  WaterLoc(loc: 'AA Rano', latd: 6.429383, long: 3.265559),
  WaterLoc(loc: 'Ajah', latd: 6.477753, long: 3.563582),
  WaterLoc(loc: 'Apapa', latd: 6.448219, long: 3.374743),
  WaterLoc(loc: 'Badagry', latd: 6.416819, long: 2.875190),
  WaterLoc(loc: 'Badore', latd: 6.448166, long: 3.374893),
  WaterLoc(loc: 'Bariga', latd: 6.529512, long: 3.399887),
  WaterLoc(loc: 'Beta Jetty', latd: 6.439611, long: 3.354670),
  WaterLoc(loc: 'Bond', latd: 6.427740, long: 3.258621),
  WaterLoc(loc: 'CMS', latd: 6.449251, long: 3.389732),
  WaterLoc(loc: 'Coconut', latd: 6.437870, long: 3.336691),
  WaterLoc(loc: 'Ebute Ero', latd: 6.462734, long: 3.382343),
  WaterLoc(loc: 'Fairway Buoy', latd: 6.326911, long: 3.427045),
  WaterLoc(loc: 'Five Cowries', latd: 6.441961, long: 3.426962),
  WaterLoc(loc: 'Folawiyo', latd: 6.433469, long: 3.368507),
  WaterLoc(loc: 'Gbaji', latd: 6.416377, long: 2.875498),
  WaterLoc(loc: 'Heyden', latd: 6.465432, long: 3.378189),
  WaterLoc(loc: 'Ibru', latd: 6.437463, long: 3.331980),
  WaterLoc(loc: 'Ijegun', latd: 6.427809, long: 3.258970),
  WaterLoc(loc: 'Ikorodu', latd: 6.601925, long: 3.486072),
  WaterLoc(loc: 'Ilashe Jetty', latd: 6.406380, long: 3.205285),
  WaterLoc(loc: 'Karma Jetty', latd: 6.445201, long: 3.349942),
  WaterLoc(loc: 'Lagos State Jetty', latd: 6.443219, long: 3.433668),
  WaterLoc(loc: 'Lekki Addax', latd: 6.436832, long: 3.441963),
  WaterLoc(loc: 'Liverpool Jetty', latd: 6.439139, long: 3.359058),
  WaterLoc(loc: 'Mile 2', latd: 6.458269, long: 3.308459),
  WaterLoc(loc: 'MRS Oil Jetty', latd: 6.431948, long: 3.336047),
  WaterLoc(loc: 'NACJ', latd: 6.412297, long: 3.397608),
  WaterLoc(loc: 'Nigerdock', latd: 6.426784, long: 3.339019),
  WaterLoc(loc: 'Ojo', latd: 6.450553, long: 3.162721),
  WaterLoc(loc: 'Paradise', latd: 6.439001, long: 3.411509),
  WaterLoc(loc: 'PWA', latd: 6.456994, long: 3.371419),
  WaterLoc(loc: 'Rain Oil Jetty', latd: 6.429131, long: 3.262269),
  WaterLoc(loc: 'Sabokoji', latd: 6.432771, long: 3.376567),
  WaterLoc(loc: 'SBM Lagos', latd: 6.371952, long: 3.347051),
  WaterLoc(loc: 'Snake Island', latd: 6.427557, long: 3.334878),
  WaterLoc(loc: 'Tincan', latd: 6.435971, long: 3.342917),
  WaterLoc(loc: 'Tolu', latd: 6.436744, long: 3.344044),
  WaterLoc(loc: 'Volswagen', latd: 6.452909, long: 3.205545),
  WaterLoc(loc: 'Eleganza Private Jetty', latd: 6.464342, long: 3.430577),
  WaterLoc(loc: 'Festac Jetty', latd: 6.474558, long: 3.294300),
];
