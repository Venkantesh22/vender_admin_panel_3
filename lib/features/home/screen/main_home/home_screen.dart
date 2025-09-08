// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/screen/user_info_sidebar.dart';
import 'package:samay_admin_plan/features/home/user_list/screen/user_list.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class HomeScreen extends StatefulWidget {
  final DateTime date;
  const HomeScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppointModel? selectedOrder;
  int? selectIndex;
  UserModel? selectedUser;

  // Function to update the selected order
  void _onBookingSelected(AppointModel order, UserModel user, int index) {
    setState(() {
      selectedOrder = order;
      selectedUser = user;
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    SalonModel? salonModal = appProvider.getSalonInformation;

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: const MobileDrawer(),
      key: _scaffoldKey,
      body: ResponsiveLayout(
        mobile: homeMobileWidget(salonModal),
        tablet: homeTabWidget(salonModal),
        desktop: homeWedWidget(salonModal),
      ),
    );
  }

  Widget homeMobileWidget(SalonModel salonModal) {
    return UserList(
      date: widget.date,
      salonModel: salonModal,
      onBookingSelected: _onBookingSelected,
    );
  }

  Widget homeWedWidget(SalonModel salonModal) {
    BookingProvider bookingProvider  = Provider.of<BookingProvider>(context);
    return Row(
     
      children: [
        // Left Side: User Booking List
        Expanded(
          child: UserList(
            date: widget.date,
            salonModel: salonModal,
            onBookingSelected: _onBookingSelected,
          ),
        ),
        // Right Side: Detailed User Information
        Container(
          decoration: const BoxDecoration(
            color: AppColor.sideBarBgColor,
            border: Border(
              left: BorderSide(width: 2.0, color: Colors.black),
            ),
          ),
          width: Dimensions.screenWidth / 3,
          child: selectedOrder != null
              ? UserInfoSideBar(
                  appointModel: selectedOrder!,
                  user: selectedUser!,
                  index: selectIndex!,
                )
              : const Center(
                  child: Text("Select a booking to see details"),
                ),
        ),
      ],
    );
  }

  Row homeTabWidget(SalonModel salonModal) {
    return Row(
      children: [
        // Left Side: User Booking List
        Expanded(
          child: UserList(
            date: widget.date,
            salonModel: salonModal,
            onBookingSelected: _onBookingSelected,
          ),
        ),
        // Right Side: Detailed User Information
        Container(
          decoration: const BoxDecoration(
            color: AppColor.sideBarBgColor,
            border: Border(
              left: BorderSide(width: 2.0, color: Colors.black),
            ),
          ),
          width: Dimensions.screenWidth / 2.5,
          child: selectedOrder != null
              ? UserInfoSideBar(
                  appointModel: selectedOrder!,
                  user: selectedUser!,
                  index: selectIndex!,
                )
              : const Center(
                  child: Text("Select a booking to see details"),
                ),
        ),
      ],
    );
  }
}
