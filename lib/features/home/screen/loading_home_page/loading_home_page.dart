import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/home/screen/accountBanned/account_banned.dart';
import 'package:samay_admin_plan/features/home/screen/accountNotValidate/account_not_validate.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeData();
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

      debugPrint("Fetching salon and admin info...");

      await appProvider.getAdminInfoFirebase();
      await appProvider.getSalonInfoFirebase();
      _salonModel = appProvider.getSalonInformation;
      await appProvider.callBackFunction();
      await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      await serviceProvider
          .callBackFunction(appProvider.getSalonInformation.id);
      await bookingProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      await calenderProvider.setToday(_today);
      await bookingProvider.setSamaySalonSetting();
      settingProvider
          .callbackSettingProvider(appProvider.getSalonInformation.id);

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
    return Scaffold(
      body: _isLoading
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
                  // return AddNewAppointment(salonModel: _salonModel!);
                  return HomeScreen(date: DateTime.now());
                } else {
                  return const AccountNotValidatePage();
                }
              },
            ),
    );
  }
}
