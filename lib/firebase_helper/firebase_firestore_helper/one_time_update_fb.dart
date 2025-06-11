import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OneTimeUpdateFb {
  static final OneTimeUpdateFb instance = OneTimeUpdateFb();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateAllCategoriesWithServiceFor(String salonId) async {
    final categories = await _firebaseFirestore
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("category")
        .get();

    for (var doc in categories.docs) {
      // Only update if serviceFor is missing or null
      if (!doc.data().containsKey('serviceFor') || doc['serviceFor'] == null) {
        await doc.reference.update({'serviceFor': 'Both'});
      }
    }
    print('All categories updated with serviceFor = "Both"');
  }

  // Example implementation
  Future<QuerySnapshot<Map<String, dynamic>>> getAllCategories(
      String salonId) async {
    return await FirebaseFirestore.instance
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("category")
        .where('salonId', isEqualTo: salonId)
        .get();
  }

  Future<void> updateAllSuperCategoriesWithServiceFor(String salonId) async {
    final superCate = await _firebaseFirestore
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("supercategory")
        .get();

    for (var doc in superCate.docs) {
      // Only update if serviceFor is missing or null
      if (!doc.data().containsKey('serviceFor') || doc['serviceFor'] == null) {
        await doc.reference.update({'serviceFor': 'Both'});
      }
    }
    print('All supercategories updated with serviceFor = "Both"');
  }

  // Example implementation
  Future<QuerySnapshot<Map<String, dynamic>>> getAllSCategories(
      String salonId) async {
    return await _firebaseFirestore
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("supercategory")
        .get();
  }
}
