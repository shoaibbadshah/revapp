import 'dart:convert';

import 'package:avenride/app/app.logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avenride/exceptions/firestore_api_exception.dart';
import 'package:avenride/models/application_models.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference ridersCollection =
      FirebaseFirestore.instance.collection('riders');
  final CollectionReference carRideCollection =
      FirebaseFirestore.instance.collection('CarRide');
  final CollectionReference boatRideCollection =
      FirebaseFirestore.instance.collection('BoatRide');
  final CollectionReference taxiRideCollection =
      FirebaseFirestore.instance.collection('TaxiRide');
  final CollectionReference kekeRideCollection =
      FirebaseFirestore.instance.collection('Keke');
  final CollectionReference ambulanceRideCollection =
      FirebaseFirestore.instance.collection('Ambulance');
  final CollectionReference deliveryRideCollection =
      FirebaseFirestore.instance.collection('Delivery');
  final CollectionReference deliveryservicesRideCollection =
      FirebaseFirestore.instance.collection('DeliveryServices');
  final CollectionReference updateLocationCollection =
      FirebaseFirestore.instance.collection('locations');
  Future<void> createUser({required User user}) async {
    log.i('user:$user');

    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson());
      log.v('UserCreated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  Future checkUser({required User user}) async {
    try {
      final userDocument = usersCollection.where('id', isEqualTo: user.id);

      userDocument.get().then((value) {
        // ignore: unnecessary_null_comparison
        if (value == null) {
          log.v('User is nul');
        }
      });
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateCurrentLocation({required GeoPoint geoPoint}) async {
    try {
      final userDocument = updateLocationCollection.doc('rides');
      userDocument.update({
        'location': geoPoint,
      });
      log.v('Curretn Location Updated');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Curretn Location',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateAddress(
      {required String address, required User user}) async {
    log.i('user address:$address and user data: $user');

    try {
      final userDocument = usersCollection.doc(user.id);
      log.v('UserCreated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update user address',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateRide(
      {required String identifier,
      required String data,
      required User user}) async {
    try {
      final userDocument =
          carRideCollection.where('userId', isEqualTo: user.id);
      userDocument.get().then((value) {});
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update car ride',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateRider(
      {required Map<String, dynamic> data, required String user}) async {
    try {
      final userDocument = usersCollection.doc(user);
      userDocument.update(data);
      log.v('UserUpdated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update user address',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateTaxiPaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = taxiRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Taxi PaymentInfo updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Taxi PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateCarPaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = carRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Car Payment Info updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Car PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateAmbulancePaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = ambulanceRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Ambulance Payment Info updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Ambulance PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateBoatPaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = boatRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Boat Payment Info updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Boat PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateDeliveryPaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = deliveryRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Delivery Payment Info updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Delivery PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> updateDeliveryServicesPaymentInfo(
      {required Map<String, dynamic> data,
      required User user,
      required String docId}) async {
    try {
      final userDocument = deliveryservicesRideCollection.doc(docId);
      userDocument.update(data);
      log.v('Delivery Services Payment Info updated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to update Delivery PaymentInfo',
        devDetails: '$error',
      );
    }
  }

  Future<void> deleteBooking(
      {required String collectionName,
      required User user,
      required String docId}) async {
    if (collectionName == 'boat') {
      try {
        final userDocument = boatRideCollection.doc(docId);
        userDocument.delete();
        log.v('Boat Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
    if (collectionName == 'car') {
      try {
        final userDocument = carRideCollection.doc(docId);
        userDocument.delete();
        log.v('Car Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
    if (collectionName == 'taxi') {
      try {
        final userDocument = taxiRideCollection.doc(docId);
        userDocument.delete();
        log.v('Taxi Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
    if (collectionName == 'ambulance') {
      try {
        final userDocument = ambulanceRideCollection.doc(docId);
        userDocument.delete();
        log.v('Ambulacne Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
    if (collectionName == 'delivery') {
      try {
        final userDocument = deliveryRideCollection.doc(docId);
        userDocument.delete();
        log.v('Delivery Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
    if (collectionName == 'deliveryservices') {
      try {
        final userDocument = deliveryservicesRideCollection.doc(docId);
        userDocument.delete();
        log.v('Delivery Service Booking is deleted successfully');
      } catch (error) {
        throw FirestoreApiException(
          message: 'Failed to delete Booking',
          devDetails: '$error',
        );
      }
    }
  }

  Future<String> createCarRide(
      {required Map carride, required User user}) async {
    try {
      final userDocument = carRideCollection.doc();
      await userDocument.set(carride);
      log.v('CarRide created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a ride',
        devDetails: '$error',
      );
    }
  }

  Future<String> createBoatRide(
      {required Map carride, required User user}) async {
    try {
      final userDocument = boatRideCollection.doc();
      await userDocument.set(carride);
      log.v('BoatRide created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a boat ride',
        devDetails: '$error',
      );
    }
  }

  Future<String> createDeliveryRide(
      {required Map carride, required User user}) async {
    log.i('Delivery Details: $carride and user data: $user');

    try {
      final userDocument = deliveryRideCollection.doc();
      await userDocument.set(carride);
      log.v('delivery created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a delivery ride',
        devDetails: '$error',
      );
    }
  }

  Future<String> createDeliveryServices(
      {required Map carride, required User user}) async {
    try {
      final userDocument = deliveryservicesRideCollection.doc();
      await userDocument.set(carride);
      log.v('delivery service created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a delivery service',
        devDetails: '$error',
      );
    }
  }

  Future<String> createTaxiRide(
      {required Map carride, required User user}) async {
    log.i('Ride Details: $carride and user data: $user');

    try {
      final userDocument = taxiRideCollection.doc();
      await userDocument.set(carride);
      log.v('Taxi created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a Taxi',
        devDetails: '$error',
      );
    }
  }

  Future<String> createKeke({required Map carride, required User user}) async {
    log.i('Ride Details: $carride and user data: $user');

    try {
      final userDocument = kekeRideCollection.doc();
      await userDocument.set(carride);
      log.v('Keke created at ${userDocument.path}');
      return userDocument.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a keke',
        devDetails: '$error',
      );
    }
  }

  Future<String> createAmbulance(
      {required Map carride, required User user}) async {
    try {
      final userDocumen = ambulanceRideCollection.doc();
      await userDocumen.set(carride);
      log.v('Ambulance created at ${userDocumen.path}');
      return userDocumen.id;
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create a Ambulance',
        devDetails: '$error',
      );
    }
  }

  Future<User?> getUser({required String userId}) async {
    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }
      Object? data = userDoc.data();
      String s = json.encode(data!);
      Map<String, dynamic> user = jsonDecode(s);
      return User.fromJson(user);
    } else {
      throw FirestoreApiException(
          message:
              'Your userId passed in is empty. Please pass in a valid user if from your Firebase user.');
    }
  }

  Future getDriver({required String userId}) async {
    if (userId.isNotEmpty) {
      try {
        final userDoc = await ridersCollection.doc(userId).get();
        if (!userDoc.exists) {
          log.v('We have no user with id $userId in our database');
          return null;
        }
        Object? data = userDoc.data();
        String s = json.encode(data!);
        Map<String, dynamic> user = jsonDecode(s);
        return user;
      } catch (e) {
        return e;
      }
    } else {
      return null;
    }
  }

  getBook({required String userId}) async {
    return boatRideCollection.where("userId", isEqualTo: userId).snapshots();
  }

  Stream<List<Users>> streamuser(String userId) {
    return usersCollection.where('id', isEqualTo: userId).snapshots().map(
        (list) => list.docs.map((doc) => Users.fromFirestore(doc)).toList());
  }

  Stream<List<BoatModel>> streamboat(String userId) {
    return boatRideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledDate', descending: true)
        .orderBy('scheduleTime', descending: true)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => BoatModel.fromFirestore(doc)).toList());
  }

  Stream<List<CarModel>> streamcar(String userId) {
    return carRideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledDate', descending: true)
        .orderBy('scheduleTime', descending: true)
        .snapshots()
        .map((list) => list.docs.map((doc) {
              return CarModel.fromFirestore(doc);
            }).toList());
  }

  Stream<List<TaxiModel>> streamtaxi(String userId) {
    return taxiRideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledDate', descending: true)
        .orderBy('scheduleTime', descending: true)
        .snapshots()
        .map((list) => list.docs.map((doc) {
              return TaxiModel.fromFirestore(doc);
            }).toList());
  }

  Stream<List<AmbulanceModel>> streamambulance(String userId) {
    return ambulanceRideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledDate', descending: true)
        .orderBy('scheduleTime', descending: true)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => AmbulanceModel.fromFirestore(doc)).toList());
  }

  Stream<List<DeliveryModel>> streamdelivery(String userId) {
    try {
      return deliveryRideCollection
          .where('userId', isEqualTo: userId)
          .orderBy('scheduledDate', descending: true)
          .orderBy('scheduleTime', descending: true)
          .snapshots()
          .map((list) => list.docs
              .map((doc) => DeliveryModel.fromFirestore(doc))
              .toList());
    } catch (error) {
      log.v(error);
      throw Exception('Error in getting delivery data');
    }
  }

  Stream<List<DeliveryServicesModel>> streamdeliveryservices(String userId) {
    try {
      return deliveryservicesRideCollection
          .where('userId', isEqualTo: userId)
          .orderBy('scheduledDate', descending: true)
          .orderBy('scheduleTime', descending: true)
          .snapshots()
          .map((list) => list.docs
              .map((doc) => DeliveryServicesModel.fromFirestore(doc))
              .toList());
    } catch (error) {
      log.v(error);
      throw Exception('Error in getting delivery data');
    }
  }

  Stream<CarModelRideDetail> streamRide(
    String collectionType,
    String rideId,
  ) {
    try {
      return FirebaseFirestore.instance
          .collection(collectionType)
          .doc(rideId)
          .snapshots()
          .map((doc) => CarModelRideDetail.fromFirestore(doc));
    } catch (error) {
      throw Exception('Error in getting delivery data');
    }
  }

  Stream<BoatRideDetailModel> streamBoatRide(
    String collectionType,
    String rideId,
  ) {
    try {
      return FirebaseFirestore.instance
          .collection(collectionType)
          .doc(rideId)
          .snapshots()
          .map((doc) => BoatRideDetailModel.fromFirestore(doc));
    } catch (error) {
      throw Exception('Error in getting delivery data');
    }
  }

  Stream<DriverModel> streamDriver(
    String rideId,
  ) {
    try {
      return FirebaseFirestore.instance
          .collection('riders')
          .doc(rideId)
          .snapshots()
          .map((doc) => DriverModel.fromFirestore(doc));
    } catch (error) {
      throw Exception(error);
    }
  }
}
