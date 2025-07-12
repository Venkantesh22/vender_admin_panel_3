import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.bgForAdminCreateSec,
          child: Center(
            child: Container(
              margin: ResponsiveLayout.isMobile(context)
                  ? EdgeInsets.symmetric(
                      horizontal: Dimensions.dimensionNo12,
                    )
                  : ResponsiveLayout.isTablet(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimensionNo60,
                        )
                      : null,
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimensionNo10
                      : Dimensions.dimensionNo30,
                  vertical: Dimensions.dimensionNo20),
              // color: Colors.green,
              color: Colors.white,
              width: ResponsiveLayout.isDesktop(context)
                  ? Dimensions.screenWidth / 1.5
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: headingTextOFPage(
                      context,
                      'About Us',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.dimensionNo10),
                    child: const Divider(),
                  ),
                  Text(
                      "Samay is an all-in-one super app designed to simplify the appointment booking process across a wide range of services, including doctors, salons, spas, gyms, yoga classes, job searches, tattoo artists, events, school appointments, hotels, and restaurants. Our platform allows users to effortlessly schedule appointments, manage their booking history, and store medical records, all in one unified interface.",
                      style: textStyle(context)),
                  SizedBox(
                    height: Dimensions.dimensionNo10,
                  ),
                  Text(
                      "For businesses, Samay offers a comprehensive ONE-Solution management tool. This powerful feature integrates daily appointment updates, calendar management, sales tracking, business reporting, product sales, and job postings into a single, cohesive platform. By using Samay, businesses can streamline operations, enhance efficiency, and focus on growth without the stress of managing multiple systems. Our goal is to revolutionize the way appointments and bookings are managed, providing a seamless experience for both service providers and customers. We envision a future where scheduling is effortless and efficient.",
                      style: textStyle(context)),
                  SizedBox(
                    height: Dimensions.dimensionNo10,
                  ),
                  Text(
                      "One of Samay's robust features is its ability to store appointment histories and medical records. For hospital and medical appointments, Samay securely stores users' medical histories, including previous appointments, medical conditions, prescribed treatments, test results, and other relevant health information. This comprehensive view of a patient's health background is accessible to doctors during appointments, enabling informed decision-making and better care. Patients benefit from not having to repeatedly provide their medical history, saving time and reducing the risk of missing critical information. They can also track their health progress and maintain a record of all medical visits and treatments in one place.",
                      style: textStyle(context)),
                  SizedBox(
                    height: Dimensions.dimensionNo10,
                  ),
                  Text(
                      " For other appointments, such as those for salons, spas, and gyms, Samay maintains a history of all bookings. This allows users to easily view past appointments and rebook services. Service providers can access client history to offer personalized services based on past interactions, enhancing customer satisfaction and loyalty.",
                      style: textStyle(context)),
                  SizedBox(
                    height: Dimensions.dimensionNo10,
                  ),
                  Text(
                      "By having a unified platform that stores all appointment histories, Samay streamlines operations for both users and service providers. This reduces administrative burdens and ensures that all necessary information is readily available for every appointment.",
                      style: textStyle(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(BuildContext context) {
    return TextStyle(
      color: Colors.black,
      fontSize: ResponsiveLayout.isMobile(context)
          ? Dimensions.dimensionNo12
          : Dimensions.dimensionNo16,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w500,
    );
  }
}
