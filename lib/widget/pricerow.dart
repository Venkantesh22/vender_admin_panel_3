import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class PriceRow extends StatelessWidget {
  final ServiceModel serviceModel;

  const PriceRow({super.key, required this.serviceModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: serviceModel.discountInPer != 0.0
          ? ResponsiveLayout.isMobile(context)
              ? [
                  // Discount Percentage
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: serviceModel.discountInPer.toString(),
                                  style: TextStyle(
                                    color: AppColor.buttonColor,
                                    fontSize: Dimensions.dimensionNo14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "%",
                                  style: TextStyle(
                                    color: AppColor.buttonColor,
                                    fontSize: 
                                      Dimensions
                                            .dimensionNo14 // Smaller font for mobile
                                       ,
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: Dimensions.dimensionNo8),
                          // Original Price with rupee symbol using Text.rich (strikethrough and gray)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '₹ ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 
                                      Dimensions
                                            .dimensionNo14 // Smaller font for mobile
                                       ,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: serviceModel.originalPrice.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 
                                      Dimensions
                                            .dimensionNo14 // Smaller font for mobile
                                       ,
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: Dimensions.dimensionNo8),
                      // Final Price with rupee symbol (normal, no strikethrough)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '₹',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 
                                  Dimensions
                                        .dimensionNo14 // Smaller font for mobile
                                   ,
                              ),
                            ),
                            TextSpan(
                              text: serviceModel.price.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 
                                  Dimensions
                                        .dimensionNo14 // Smaller font for mobile
                                   ,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]
              : [
                  // Discount Percentage
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: serviceModel.discountInPer.toString(),
                          style: TextStyle(
                            color: AppColor.buttonColor,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "%",
                          style: TextStyle(
                            color: AppColor.buttonColor,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: Dimensions.dimensionNo8),
                  // Original Price with rupee symbol using Text.rich (strikethrough and gray)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '₹ ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        TextSpan(
                          text: serviceModel.originalPrice.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimensions.dimensionNo8),
                  // Final Price with rupee symbol (normal, no strikethrough)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '₹',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                          ),
                        ),
                        TextSpan(
                          text: serviceModel.price.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 
                              Dimensions
                                    .dimensionNo14 // Smaller font for mobile
                               ,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
          : [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '₹',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 
                          Dimensions
                                .dimensionNo14 // Smaller font for mobile
                           ,
                      ),
                    ),
                    TextSpan(
                      text: serviceModel.price.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 
                          Dimensions
                                .dimensionNo14 // Smaller font for mobile
                           ,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}
