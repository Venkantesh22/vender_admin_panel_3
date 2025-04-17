import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/models/image_model/image_model.dart';
import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';

class SamayFB {
  static SamayFB instance = SamayFB();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _user = FirebaseAuth.instance;

  Future<SamaySalonSettingModel?> fetchSalonSettingData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch the `Samay` collection
      QuerySnapshot samaySnapshot = await firestore.collection('Samay').get();

      if (samaySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document in the `Samay` collection
        for (var samayDoc in samaySnapshot.docs) {
          print('Found Samay document with ID: ${samayDoc.id}'); // Debug
          GlobalVariable.samayCollectionId = samayDoc.id;

          // Fetch the `salonSetting` collection under the current `Samay` document
          QuerySnapshot salonSettingSnapshot = await firestore
              .collection('Samay')
              .doc(samayDoc.id) // Use the current `Samay` document ID
              .collection('salonSetting')
              .get();

          // Check if `salonSetting` contains any documents
          if (salonSettingSnapshot.docs.isNotEmpty) {
            // Since there's only one document in `salonSetting`, fetch the first
            DocumentSnapshot salonSettingDoc = salonSettingSnapshot.docs.first;

            print(
                'Found salonSetting document with ID: ${salonSettingDoc.id}'); // Debug
            GlobalVariable.salonSettingCollectionId = salonSettingDoc.id;

            // Convert Firestore document to `SalonSettingModel`
            SamaySalonSettingModel samaySalonSettingModel =
                SamaySalonSettingModel.fromJson(
              salonSettingDoc.data() as Map<String, dynamic>,
            );

            return samaySalonSettingModel;
          } else {
            print('No documents found in the `salonSetting` collection.');
            return null;
          }
        }
      } else {
        print('No documents found in the `Samay` collection.');
        return null;
      }
    } catch (e) {
      print('Error fetching salon setting: $e');
      return null;
    }
    return null;
  }

  Future<int> incrementSalonAppointmentNo() async {
    int newAppointmentNo = 0;

    try {
      // Reference to the document within the nested collection "salon"
      DocumentReference salonDocRef = _firebaseFirestore
          .collection("Samay")
          .doc(GlobalVariable.samayCollectionId)
          .collection("salonSetting")
          .doc(GlobalVariable.salonSettingCollectionId);

      // Use a transaction to ensure atomicity
      await _firebaseFirestore.runTransaction(
        (transaction) async {
          // Get the current value of appointmentNo
          DocumentSnapshot snapshot = await transaction.get(salonDocRef);

          if (!snapshot.exists) {
            throw Exception("Document does not exist!");
          }

          // Get the current appointmentNo value
          int currentAppointmentNo = snapshot.get('appointmentNo');

          // Increment the appointmentNo by 1
          newAppointmentNo = currentAppointmentNo + 1;

          // Update the document with the new appointmentNo
          transaction.update(salonDocRef, {'appointmentNo': newAppointmentNo});
          GlobalVariable.appointmentNO = newAppointmentNo;
          print("Appointment NO $newAppointmentNo");
          print(
              "Appointment NO  GlobalVariable.appointmentNO  ${GlobalVariable.appointmentNO}");
        },
      );
      print("appointmentNo incremented successfully!");

      return newAppointmentNo;
    } catch (e) {
      print("Error incrementing appointmentNo: $e");
      rethrow;
    }
  }

  //!----------------------------- Fetch Super category images -------------------------------------
  Future<List<ImageModel>> getSuperCateimageFB() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("ImagesSuperCate").get();
      List<ImageModel> imageList =
          querySnapshot.docs.map((e) => ImageModel.fromJson(e.data())).toList();
      return imageList;
    } catch (e) {
      print('Error fetching logimageFB images: ${e.toString()}');
      throw Exception('Failed to load logimageFB images');
    }
  }

  // Fetch logo images
  // Future<List<ImageModel>> logimageFB() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collection("ImagesLogo").get();
  //     List<ImageModel> imageList =
  //         querySnapshot.docs.map((e) => ImageModel.fromJson(e.data())).toList();
  //     return imageList;
  //   } catch (e) {
  //     print('Error fetching log images: ${e.toString()}');
  //     throw Exception('Failed to load log images');
  //   }
  // }
}
