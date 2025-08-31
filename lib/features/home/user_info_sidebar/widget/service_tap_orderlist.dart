import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/custom_chip.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/pricerow.dart';

class SingleServiceOrderList extends StatelessWidget {
  final ServiceModel serviceModel;
  final bool showDelectIcon;

  const SingleServiceOrderList({
    super.key,
    required this.serviceModel,
    required this.showDelectIcon,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    Duration? serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimensionNo12),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.dimensionNo5,
          horizontal: Dimensions.dimensionNo12),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimensionNo12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '▪️ ${serviceModel.servicesName}',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo14,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimensionNo8),
                      child: Text(
                        'service code : ${serviceModel.serviceCode}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.dimensionNo10,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomChip(
                  text: serviceModel.categoryName,
                )
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.dimensionNo5,
                  ),
                  Row(
                    children: [
                      Text(
                        "During : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimensionNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      serviceDuration.inHours >= 1
                          ? Text(
                              ' ${serviceDuration.inHours.toString()}h : ',
                              style: TextStyle(
                                color: AppColor.serviceTapTextColor,
                                fontSize: Dimensions.dimensionNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        "${(serviceDuration.inMinutes % 60).toString()}min",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimensionNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.dimensionNo5,
                  ),
                  PriceRow(serviceModel: serviceModel),
                ],
              ),
              const Spacer(),
              showDelectIcon
                  ? IconButton(
                      onPressed: () {
                        try {
                          showLoaderDialog(context);
                          // appProvider.removeServiceToWatchList(serviceModel);
                          // appProvider.calculateSubTotal();
                          // appProvider.calculateTotalBookingDuration();

                          // Navigator.of(context, rootNavigator: true).pop();

                          showMessage('Service is removed from Watch List');
                        } catch (e) {
                          showMessage(
                              'Error occurred while removing service from Watch List: ${e.toString()}');
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: Dimensions.dimensionNo30,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: Dimensions.dimensionNo20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
