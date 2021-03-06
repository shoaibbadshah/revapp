import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:avenride/app/router_names.dart';

part 'application_models.freezed.dart';
part 'application_models.g.dart';

@freezed
class User with _$User {
  User._();

  factory User({
    required String id,
    String? email,
    String? defaultAddress,
    String? name,
    String? photourl,
    String? personaldocs,
    String? bankdocs,
    String? vehicle,
    String? vehicledocs,
    String? pushToken,
    String? mobileNo,
    List? notification,
    List? favourites,
    List? cards,
  }) = _User;

  bool get hasAddress => defaultAddress?.isNotEmpty ?? false;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

class Users {
  final String id;
  final String email;
  final String defaultAddress;
  final String name;
  final String photourl;
  final String personaldocs;
  final String bankdocs;
  final String vehicle;
  final String mobileNo;
  final String vehicledocs;
  final bool isVehicle;
  final bool isBoat;
  final List notification;
  final List favourites;
  final List cards;

  Users({
    required this.id,
    required this.isVehicle,
    required this.isBoat,
    required this.email,
    required this.defaultAddress,
    required this.mobileNo,
    required this.name,
    required this.notification,
    required this.photourl,
    required this.personaldocs,
    required this.bankdocs,
    required this.vehicle,
    required this.vehicledocs,
    required this.favourites,
    required this.cards,
  });

  factory Users.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return Users(
      id: doc.id,
      isBoat: false,
      isVehicle: false,
      bankdocs: data['bankdocs'],
      notification: data['notification'],
      mobileNo: data['mobileNo'],
      defaultAddress: '',
      email: data['email'],
      name: data['name'] ?? '',
      personaldocs: data['personaldocs'],
      photourl: data['photourl'] == null ? '' : data['photourl'],
      vehicle: data['vehicle'],
      vehicledocs: data['vehicledocs'],
      favourites: data['favourites'] ?? [],
      cards: data['cards'] ?? [],
    );
  }
}

class DeliveryServicesModel {
  final String paymentType;
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String carType;
  final String laguageType;
  final String laguageSize;
  final String distace;
  final String paymentStatus;
  final String price;
  final String id;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;
  final bool rideEnded;
  DeliveryServicesModel(
      {required this.destination,
      required this.distace,
      required this.price,
      required this.selectedPlace,
      required this.dropoffplace,
      required this.laguageSize,
      required this.laguageType,
      required this.carType,
      required this.paymentStatus,
      required this.id,
      required this.rideEnded,
      required this.paymentType,
      required this.startLocation,
      required this.scheduleTime,
      required this.scheduledDate});

  factory DeliveryServicesModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return DeliveryServicesModel(
      paymentType: data['PaymentType'],
      rideEnded: data['rideEnded'] ?? false,
      carType: data['CarType'] ?? "Bike",
      destination: data['destination'],
      startLocation: data['startLocation'],
      id: doc.id,
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
      laguageType: data['laguageType'] ?? "",
      laguageSize: data['laguageSize'] ?? "",
      paymentStatus: data['paymentStatus'] ?? Pending,
      scheduleTime: data['scheduleTime'],
      scheduledDate: data['scheduledDate'],
      distace: data['distace'] ?? '0',
      price: data['price'].toString(),
    );
  }
}

class BoatModel {
  final String paymentType;
  final String dropLocation;
  final String pickLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String boatType;
  final String paymentStatus;
  final String id;
  final double pickupLat;
  final double pickupLong;
  final double dropoffLat;
  final String price;
  final bool rideEnded;
  final double dropoffLong;

  BoatModel(
      {required this.paymentType,
      required this.dropLocation,
      required this.paymentStatus,
      required this.pickLocation,
      required this.scheduleTime,
      required this.rideEnded,
      required this.pickupLat,
      required this.pickupLong,
      required this.dropoffLat,
      required this.price,
      required this.dropoffLong,
      required this.id,
      required this.boatType,
      required this.scheduledDate});

  factory BoatModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return BoatModel(
      paymentType: data['PaymentType'].toString(),
      dropLocation: data['dropLocation'].toString(),
      paymentStatus: data['paymentStatus'].toString(),
      pickLocation: data['pickLocation'].toString(),
      id: doc.id,
      scheduleTime: data['scheduleTime'],
      price: data['price'].toString(),
      scheduledDate: data['scheduledDate'],
      boatType: data['BoatType'],
      pickupLat: data['pickupLat'],
      pickupLong: data['pickupLong'],
      dropoffLat: data['dropoffLat'],
      rideEnded: data['rideEnded'] ?? false,
      dropoffLong: data['dropoffLong'],
    );
  }
}

class BoatRideDetailModel {
  final String paymentType;
  final String dropLocation;
  final String pickLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String boatType;
  final String paymentStatus;
  final String id;
  final double pickupLat;
  final double pickupLong;
  final double dropoffLat;
  final String price;
  final bool rideEnded;
  final double dropoffLong;
  final String pushToken;
  final String rideType;
  final String otp;
  final String drivers;

  BoatRideDetailModel({
    required this.paymentType,
    required this.dropLocation,
    required this.paymentStatus,
    required this.pickLocation,
    required this.scheduleTime,
    required this.pickupLat,
    required this.pickupLong,
    required this.dropoffLat,
    required this.price,
    required this.dropoffLong,
    required this.id,
    required this.boatType,
    required this.otp,
    required this.drivers,
    required this.rideEnded,
    required this.pushToken,
    required this.rideType,
    required this.scheduledDate,
  });

  factory BoatRideDetailModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return BoatRideDetailModel(
      drivers: data['drivers'] ?? '',
      paymentType: data['PaymentType'].toString(),
      dropLocation: data['dropLocation'].toString(),
      paymentStatus: data['paymentStatus'].toString(),
      pickLocation: data['pickLocation'].toString(),
      id: doc.id,
      rideEnded: data['RideEnded'] ?? false,
      scheduleTime: data['scheduleTime'],
      price: data['price'].toString(),
      scheduledDate: data['scheduledDate'],
      boatType: data['BoatType'],
      pickupLat: data['pickupLat'],
      pickupLong: data['pickupLong'],
      dropoffLat: data['dropoffLat'],
      dropoffLong: data['dropoffLong'],
      pushToken: data['pushToken'] ?? '',
      rideType: data['rideType'] ?? '',
      otp: data['otp'] ?? '',
    );
  }
}

class DeliveryModel {
  final String paymentType;
  final String dropLocation;
  final String pickLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String laguageType;
  final String laguageSize;
  final String paymentStatus;
  final String id;
  final String price;
  final double pickupLat;
  final double pickupLong;
  final double dropoffLat;
  final double dropoffLong;
  final bool rideEnded;
  DeliveryModel(
      {required this.paymentType,
      required this.dropLocation,
      required this.paymentStatus,
      required this.laguageSize,
      required this.laguageType,
      required this.pickLocation,
      required this.pickupLat,
      required this.price,
      required this.pickupLong,
      required this.dropoffLat,
      required this.rideEnded,
      required this.dropoffLong,
      required this.scheduleTime,
      required this.id,
      required this.scheduledDate});

  factory DeliveryModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return DeliveryModel(
      paymentType: data['PaymentType'],
      dropLocation: data['dropLocation'],
      paymentStatus: data['paymentStatus'],
      price: data['price'].toString(),
      laguageType: data['laguageType'],
      laguageSize: data['laguageSize'],
      pickLocation: data['pickLocation'],
      id: doc.id,
      rideEnded: data['rideEnded'] ?? false,
      pickupLat: data['pickupLat'],
      pickupLong: data['pickupLong'],
      dropoffLat: data['dropoffLat'],
      dropoffLong: data['dropoffLong'],
      scheduleTime: data['scheduleTime'],
      scheduledDate: data['scheduledDate'],
    );
  }
}

class CarModel {
  final String paymentType;
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String carType;
  final String distace;
  final String paymentStatus;
  final String price;
  final String id;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;
  final String pushToken;
  final bool rideEnded;
  final String rideType;
  CarModel(
      {required this.destination,
      required this.distace,
      required this.selectedPlace,
      required this.dropoffplace,
      required this.price,
      required this.pushToken,
      required this.carType,
      required this.paymentStatus,
      required this.rideEnded,
      required this.id,
      required this.paymentType,
      required this.startLocation,
      required this.scheduleTime,
      required this.rideType,
      required this.scheduledDate});

  factory CarModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return CarModel(
      destination: data['destination'],
      distace: data['distace'] ?? '0',
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      paymentStatus: data['paymentStatus'] ?? Pending,
      price: data['price'].toString(),
      pushToken: data['pushToken'] ?? '',
      rideType: data['rideType'] ?? '',
      scheduledDate: data['scheduledDate'],
      scheduleTime: data['scheduleTime'],
      rideEnded: data['rideEnded'] ?? false,
      paymentType: data['PaymentType'],
      carType: data['CarType'],
      startLocation: data['startLocation'],
      id: doc.id,
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
    );
  }
}

class CarModelRideDetail {
  final String paymentType;
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String carType;
  final String drivers;
  final String distace;
  final String paymentStatus;
  final String price;
  final bool rideEnded;
  final String otp;
  final String id;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;
  final String pushToken;
  final String rideType;
  CarModelRideDetail(
      {required this.destination,
      required this.distace,
      required this.selectedPlace,
      required this.dropoffplace,
      required this.price,
      required this.pushToken,
      required this.drivers,
      required this.rideEnded,
      required this.otp,
      required this.carType,
      required this.paymentStatus,
      required this.id,
      required this.paymentType,
      required this.startLocation,
      required this.scheduleTime,
      required this.rideType,
      required this.scheduledDate});

  factory CarModelRideDetail.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return CarModelRideDetail(
      drivers: data['drivers'] ?? '',
      destination: data['destination'],
      distace: data['distace'] ?? '0',
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      paymentStatus: data['paymentStatus'] ?? Pending,
      price: data['price'].toString(),
      rideEnded: data['rideEnded'] ?? false,
      pushToken: data['pushToken'] ?? '',
      rideType: data['rideType'] ?? '',
      otp: data['otp'] ?? '',
      scheduledDate: data['scheduledDate'],
      scheduleTime: data['scheduleTime'],
      paymentType: data['PaymentType'] ?? "",
      carType: data['CarType'] ?? "",
      startLocation: data['startLocation'],
      id: doc.id,
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
    );
  }
}

class DriverModel {
  final String id;
  final String email;
  final String defaultAddress;
  final String name;
  final String photourl;
  final String personaldocs;
  final String bankdocs;
  final String vehicle;
  final String vehicledocs;
  final String totalpayout;
  final String mobileNo;
  final bool isVehicle;
  final bool isBoat;
  final Map vehicleDetails;
  final List rides;
  final List cargo;
  final List car;
  final List taxi;
  final List ambulance;
  final List delivery;

  DriverModel({
    required this.id,
    required this.isVehicle,
    required this.isBoat,
    required this.email,
    required this.defaultAddress,
    required this.taxi,
    required this.ambulance,
    required this.delivery,
    required this.name,
    required this.photourl,
    required this.personaldocs,
    required this.vehicleDetails,
    required this.mobileNo,
    required this.totalpayout,
    required this.bankdocs,
    required this.vehicle,
    required this.vehicledocs,
    required this.rides,
    required this.car,
    required this.cargo,
  });

  factory DriverModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return DriverModel(
      id: doc.id,
      isBoat: false,
      isVehicle: data['vehicle'] == Confirmed ? true : false,
      bankdocs: data['bankdocs'],
      defaultAddress: '',
      mobileNo: data['mobileNo'] ?? '',
      email: data['email'],
      totalpayout: data['totalpayout'],
      name: data['name'] ?? '',
      personaldocs: data['personaldocs'],
      photourl: data['photourl'] == null ? '' : data['photourl'],
      vehicle: data['vehicle'],
      vehicleDetails: data['vehicledetails'] ?? {},
      vehicledocs: data['vehicledocs'],
      rides: data['rides'],
      cargo: data['cargo'],
      car: data['car'],
      ambulance: data['ambulance'],
      delivery: data['delivery'],
      taxi: data['taxi'],
    );
  }
}

class TaxiModel {
  final String paymentType;
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String paymentStatus;
  final String scheduledDate;
  final String distace;
  final String price;
  final String id;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;

  final bool rideEnded;
  TaxiModel(
      {required this.destination,
      required this.paymentType,
      required this.id,
      required this.distace,
      required this.dropoffplace,
      required this.selectedPlace,
      required this.paymentStatus,
      required this.price,
      required this.startLocation,
      required this.rideEnded,
      required this.scheduleTime,
      required this.scheduledDate});

  factory TaxiModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return TaxiModel(
      paymentType: data['PaymentType'],
      destination: data['destination'],
      id: doc.id,
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
      startLocation: data['startLocation'],
      paymentStatus: data['paymentStatus'] ?? Pending,
      rideEnded: data['rideEnded'] ?? false,
      scheduleTime: data['scheduleTime'],
      scheduledDate: data['scheduledDate'],
      distace: data['distace'] ?? '0',
      price: data['price'].toString(),
    );
  }
}

class KekeModel {
  final String paymentType;
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String paymentStatus;
  final String scheduledDate;
  final String distace;
  final String price;
  final String id;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;

  final bool rideEnded;
  KekeModel(
      {required this.destination,
      required this.paymentType,
      required this.id,
      required this.distace,
      required this.dropoffplace,
      required this.selectedPlace,
      required this.paymentStatus,
      required this.price,
      required this.startLocation,
      required this.rideEnded,
      required this.scheduleTime,
      required this.scheduledDate});

  factory KekeModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return KekeModel(
      paymentType: data['PaymentType'],
      destination: data['destination'],
      id: doc.id,
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
      startLocation: data['startLocation'],
      paymentStatus: data['paymentStatus'] ?? Pending,
      rideEnded: data['rideEnded'] ?? false,
      scheduleTime: data['scheduleTime'],
      scheduledDate: data['scheduledDate'],
      distace: data['distace'] ?? '0',
      price: data['price'].toString(),
    );
  }
}

class AmbulanceModel {
  final String destination;
  final String startLocation;
  final String scheduleTime;
  final String scheduledDate;
  final String distace;
  final String id;
  final String price;
  final String aae;
  final String patients;
  final String personal;
  final String pie;
  final String sa;
  final String cas;
  final String fse;
  final String le;
  final String paymentStatus;
  final GeoPoint selectedPlace;
  final GeoPoint dropoffplace;
  final bool rideEnded;
  AmbulanceModel(
      {required this.destination,
      required this.startLocation,
      required this.selectedPlace,
      required this.dropoffplace,
      required this.distace,
      required this.price,
      required this.aae,
      required this.id,
      required this.patients,
      required this.personal,
      required this.pie,
      required this.sa,
      required this.cas,
      required this.fse,
      required this.rideEnded,
      required this.le,
      required this.paymentStatus,
      required this.scheduleTime,
      required this.scheduledDate});

  factory AmbulanceModel.fromFirestore(DocumentSnapshot doc) {
    String s = json.encode(doc.data());
    Map<String, dynamic> data = jsonDecode(s);
    return AmbulanceModel(
      destination: data['destination'],
      paymentStatus: data['paymentStatus'],
      startLocation: data['startLocation'],
      id: doc.id,
      dropoffplace: GeoPoint(data['dropoffplace'][0], data['dropoffplace'][1]),
      selectedPlace:
          GeoPoint(data['selectedPlace'][0], data['selectedPlace'][1]),
      scheduleTime: data['scheduleTime'],
      rideEnded: data['rideEnded'] ?? false,
      scheduledDate: data['scheduledDate'],
      distace: data['distace'],
      price: data['price'].toString(),
      aae: data['aae'].toString(),
      cas: '',
      le: '',
      fse: '',
      patients: '',
      personal: '',
      pie: '',
      sa: '',
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

Item generateItems({required String headerText}) {
  return Item(
    headerValue: headerText,
    expandedValue: 'Details for $headerText goes here',
  );
}

// class Pay {
//   final String txref;
//   final String amount;
//   final String redirecturl;
//   final String paymentoptions;
//   final String userId;
//   final Object meta = {};
//   final Object customer = {};

//   Pay({
//     required this.expandedValue,
//     required this.headerValue,
//     this.isExpanded = false,
//   });
// }
// {
//    "tx_ref":"hooli-tx-1920bbtytty",
//    "amount":"100",
//    "currency":"NGN",
//    "redirect_url":"https://webhook.site/9d0b00ba-9a69-44fa-a43d-a82c33c36fdc",
//    "payment_options":"card",
//    "meta":{
//       "consumer_id":23,
//       "consumer_mac":"92a3-912ba-1192a"
//    },
//    "customer":{
//       "email":"user@gmail.com",
//       "phonenumber":"080****4528",
//       "name":"Yemi Desola"
//    },
//    "customizations":{
//       "title":"Pied Piper Payments",
//       "description":"Middleout isn't free. Pay the price",
//       "logo":"https://assets.piedpiper.com/logo.png"
//    }
// }
