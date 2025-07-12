import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/screen/appoint_info_mobile.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

Widget userBookingMobileWidget(
  final AppointModel appointModel,
  final UserModel? userModel,
  final int index,
  bool? isUseForReportSce,
  BuildContext context, {
  bool applyMargin = true,
}) {
  return SingleChildScrollView(
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        BookingProvider bookingProvider =
            Provider.of<BookingProvider>(context, listen: false);
        Routes.instance.push(
          widget: AppointInFoMobile(
            appointModel: appointModel,
            index: index,
            user: userModel!,
          ),
          context: context,
        );
      },
      child: Container(
        margin: applyMargin
            ? EdgeInsets.only(
                left: Dimensions.dimensionNo12,
                right: Dimensions.dimensionNo12,
                top: Dimensions.dimensionNo8,
              )
            : EdgeInsets.only(
                top: Dimensions.dimensionNo10,
              ),
        padding: EdgeInsets.all(Dimensions.dimensionNo8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.mainColor,
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // First Row: Index and User Profile
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${index.toString()}.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.dimensionNo14,
                  ),
                ),
                SizedBox(width: Dimensions.dimensionNo8),
                CircleAvatar(
                  radius: Dimensions.dimensionNo20,
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
              ],
            ),
            SizedBox(width: Dimensions.dimensionNo8),

            // Second Column: User Details and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row: User Name and Mobile Number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dimensions.dimensionNo100,
                            child: Text(
                              userModel?.name ?? 'Unknown User',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.dimensionNo16,
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.dimensionNo8),
                          Text(
                            userModel?.phone.toString() ?? 'No phone available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.dimensionNo14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Centered Status
                      Center(
                        child: StateText(status: appointModel.status),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.dimensionNo8),

                  // Row: Time Range with Stopwatch Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const FaIcon(FontAwesomeIcons.stopwatch,
                          color: Colors.white),
                      SizedBox(width: Dimensions.dimensionNo5),
                      Text(
                        '${DateFormat('hh:mm a').format(appointModel.serviceStartTime)} - '
                        '${DateFormat('hh:mm a').format(appointModel.serviceEndTime)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.dimensionNo14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
