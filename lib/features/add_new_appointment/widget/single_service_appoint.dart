import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';

Widget serviceTapAddRemoveButton(
  final ServiceModel serviceModel,
  BuildContext context,
) {
  bool isMobile = MediaQuery.of(context).size.width < 600;

  return Consumer<BookingProvider>(builder: (context, bookingProvider, child) {
    bool isAdd =
        bookingProvider.getWatchList.any((s) => s.id == serviceModel.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.dimensionNo5,
            horizontal: Dimensions.dimensionNo12,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceModel.servicesName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.serviceTapTextColor,
                  fontSize: isMobile
                      ? Dimensions.dimensionNo14
                      : Dimensions.dimensionNo16,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'S- ${serviceModel.serviceCode}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isMobile
                            ? Dimensions.dimensionNo10
                            : Dimensions.dimensionNo12,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomButton(
                    buttonColor:
                        // bookingProvider.getWatchList.contains(serviceModel)
                        isAdd ? Colors.red : AppColor.buttonColor,
                    ontap: () {
                      if (isAdd == true) {
                        bookingProvider.removeServiceToWatchList(serviceModel);
                        bookingProvider.calculateTotalBookingDuration();
                        bookingProvider.calculateSubTotal();
                        debugPrint(
                            "Remove service to list ${serviceModel.servicesName}");
                      }
                      if (isAdd == false) {
                        bookingProvider.addServiceToWatchList(serviceModel);
                        bookingProvider.calculateTotalBookingDuration();
                        bookingProvider.calculateSubTotal();
                        debugPrint(
                            "add service to list ${serviceModel.servicesName}");
                      }
                    },
                    text: isAdd ? "Remove -" : "Add+",
                    width: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimensionNo100
                        : Dimensions.dimensionNo120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  });
}
