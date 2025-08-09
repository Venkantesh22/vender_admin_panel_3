import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/add_new_appointment/screen/add_new_appointment.dart';
import 'package:samay_admin_plan/features/home/screen/accountBanned/account_banned.dart';
import 'package:samay_admin_plan/features/home/screen/accountNotValidate/account_not_validate.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/product/screen/product_add_screen.dart';
import 'package:samay_admin_plan/features/product/screen/product_screen.dart';
import 'package:samay_admin_plan/features/product/screen/single_product_details_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/one_time_update_fb.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/provider/samay_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';

class LoadingHomePage extends StatefulWidget {
  const LoadingHomePage({super.key});

  @override
  State<LoadingHomePage> createState() => _LoadingHomePageState();
}

class _LoadingHomePageState extends State<LoadingHomePage> {
  bool _isLoading = true;
  SalonModel? _salonModel;
  bool _isupdateLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> updateFun() async {
    try {
      setState(() {
        _isupdateLoading = true;
      });
      // Check if any category is missing serviceFor
      final categoriesSnapshot =
          await OneTimeUpdateFb.instance.getAllCategories(_salonModel!.id);
      bool needsUpdate = categoriesSnapshot.docs.any((doc) =>
          !doc.data().containsKey('serviceFor') || doc['serviceFor'] == null);

      final superCategoriesSnapshot =
          await OneTimeUpdateFb.instance.getAllSCategories(_salonModel!.id);
      bool needsSuperUpdate = superCategoriesSnapshot.docs.any((doc) =>
          !doc.data().containsKey('serviceFor') || doc['serviceFor'] == null);

      if (needsUpdate) {
        // Update all categories with serviceFor = "Both"
        await OneTimeUpdateFb.instance
            .updateAllCategoriesWithServiceFor(_salonModel!.id);

        debugPrint(
            "All Loading page categories updated with serviceFor = 'Both'");
      }
      if (needsSuperUpdate) {
        // Update all supercategories with serviceFor = "Both"
        await OneTimeUpdateFb.instance
            .updateAllSuperCategoriesWithServiceFor(_salonModel!.id);
        debugPrint(
            "All Loading page supercategories updated with serviceFor = 'Both'");
      }

      setState(() {
        _isupdateLoading = needsUpdate;
      });
    } catch (e) {
      debugPrint("Error updating categories: $e");
    } finally {
      setState(() {
        _isupdateLoading = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeData() async {
    try {
      DateTime _today = DateTime.now();
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      ServiceProvider serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      CalenderProvider calenderProvider =
          Provider.of<CalenderProvider>(context, listen: false);
      BookingProvider bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);
      SettingProvider settingProvider =
          Provider.of<SettingProvider>(context, listen: false);

      SamayProvider samayProvider =
          Provider.of<SamayProvider>(context, listen: false);

      debugPrint("Fetching salon and admin info...");

      await appProvider.getAdminInfoFirebase();
      await appProvider.getSalonInfoFirebase();
      _salonModel = appProvider.getSalonInformation;
      // Fetch a Samay doc Id ==  GlobalVariable.samayCollectionId = samayDoc.id;
      await samayProvider.getSamayIdPro();
      await serviceProvider
          .callBackFunction(appProvider.getSalonInformation.id);
      await calenderProvider.setToday(_today);

      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      await productProvider.getListProductPro();

      await bookingProvider.setSamaySalonSetting();
      settingProvider
          .callbackSettingProvider(appProvider.getSalonInformation.id);

      if (appProvider.getSalonInformation.isSettingAdd == true) {
        await serviceProvider
            .fetchSettingPro(appProvider.getSalonInformation.id);
        await bookingProvider
            .fetchSettingPro(appProvider.getSalonInformation.id);
      }

      updateFun();

      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching salon data in Loading page: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data Loading page: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton:
          (!_isLoading && !_isupdateLoading && _isupdateLoading)
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await updateFun();
                    setState(() {
                      _isupdateLoading = false; // Hide after update
                    });
                  },
                  label: const Text("Update Categories"),
                  icon: const Icon(Icons.update),
                )
              : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isupdateLoading
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<SalonModel?>(
                  stream: FirebaseFirestoreHelper.instance
                      .getSalonInformationFBStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                          child: Text("Salon information not found."));
                    }

                    final SalonModel salonInfo = snapshot.data!;

                    if (FirebaseAuth.instance.currentUser == null) {
                      return const Center(
                          child: Text("User is not authenticated."));
                    }

                    debugPrint("Salon information fetched: ${salonInfo.name}");

                    if (salonInfo.isAccountBanBySamay) {
                      return const AccountBanPage();
                    } else if (salonInfo.isAccountValidBySamay) {
                      return HomeScreen(date: DateTime.now());
                      // return ProductAddScreen();
                      // return ProductScreen();
                      return AddNewAppointment(
                          salonModel: appProvider.getSalonInformation);
                      // return SingleProductDetailsScreen(
                      //     productModel: productProvider.getProductList.first);
                    } else {
                      // to stop the loading dialog
                      return const AccountNotValidatePage();
                    }
                  },
                ),
    );
  }
}
