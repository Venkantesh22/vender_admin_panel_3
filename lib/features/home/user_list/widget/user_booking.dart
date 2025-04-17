// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/home/user_list/widget/user_booking_mobile.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class UserBookingTap extends StatefulWidget {
  final AppointModel appointModel;
  final UserModel? userModel;
  final int index;
  bool? isUseForReportSce;
  bool? applyMarginMobile;

  UserBookingTap({
    super.key,
    required this.appointModel,
    required this.userModel,
    required this.index,
    this.isUseForReportSce = false,
    this.applyMarginMobile = true,
  });

  @override
  State<UserBookingTap> createState() => _UserBookingTapState();
}

class _UserBookingTapState extends State<UserBookingTap> {
  bool isLoading = false;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    setState(() => isLoading = true);
    try {
      // Use the provided `userModel` if available, else fetch from Firebase
      userModel = widget.userModel;
    } catch (error) {
      debugPrint("Error fetching user data: $error");
      userModel = null;
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userModel == null) {
      return const Center(child: Text('No user data available.'));
    }

    return _buildUserContainer(userModel);
  }

  Widget _buildUserContainer(UserModel? userModel) {
    return ResponsiveLayout(
        mobile: userBookingMobileWidget(
          widget.appointModel,
          userModel,
          widget.index,
          widget.isUseForReportSce,
          context,
          applyMargin: widget.applyMarginMobile!,
        ),
        tablet: userBookingWebWiget(userModel),
        desktop: userBookingWebWiget(userModel));
  }

  // Mobile Widget

  Container userBookingWebWiget(UserModel? userModel) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.dimenisonNo12,
          right: Dimensions.dimenisonNo12,
          top: Dimensions.dimenisonNo8),
      padding: EdgeInsets.all(Dimensions.dimenisonNo8),
      height: Dimensions.dimenisonNo60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.mainColor,
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo12),
      ),
      child: Row(
        children: [
          SizedBox(
            // color: Colors.red,
            width: Dimensions.dimenisonNo30,
            child: Center(
              child: Text(
                "${widget.index.toString()}.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.dimenisonNo14,
                ),
              ),
            ),
          ),
          // SizedBox(width: Dimensions.dimenisonNo8),
          SizedBox(
            // color: Colors.yellow,
            width: Dimensions.dimenisonNo50,
            child: CircleAvatar(
              radius: Dimensions.dimenisonNo20,
              backgroundColor: Colors.green[100],
              backgroundImage:
                  (userModel?.image != null && userModel!.image.isNotEmpty)
                      ? NetworkImage(userModel.image)
                      : null,
              onBackgroundImageError: (error, stackTrace) {
                debugPrint('Image load error: $error');
              },
              child: userModel == null || userModel.image.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[600])
                  : null,
            ),
          ),
          SizedBox(width: Dimensions.dimenisonNo8),
          SizedBox(
            width: Dimensions.dimenisonNo200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel?.name ?? 'Unknown User',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.dimenisonNo16,
                  ),
                ),
                Text(
                  userModel?.phone.toString() ?? 'No phone available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.dimenisonNo14,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          widget.isUseForReportSce!
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(widget.appointModel.serviceDate),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.dimenisonNo14,
                        ),
                      ),
                      Text(
                        '${DateFormat('hh:mm a').format(widget.appointModel.serviceStartTime).toString()} To ${DateFormat('hh:mm a').format(widget.appointModel.serviceEndTime).toString()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.dimenisonNo14,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    '${DateFormat('hh:mm a').format(widget.appointModel.serviceStartTime).toString()} To ${DateFormat('hh:mm a').format(widget.appointModel.serviceEndTime).toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimenisonNo14,
                    ),
                  ),
                ),
          const Spacer(),
          SizedBox(
              width: Dimensions.dimenisonNo110,
              child:
                  Center(child: StateText(status: widget.appointModel.status))),
          SizedBox(width: Dimensions.dimenisonNo16),
        ],
      ),
    );
  }
}
