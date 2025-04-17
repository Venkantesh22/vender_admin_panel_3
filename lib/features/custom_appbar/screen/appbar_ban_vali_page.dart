// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/features/custom_appbar/widget/appbar_item.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class AppBarForBanValiPage extends StatefulWidget
    implements PreferredSizeWidget {
  const AppBarForBanValiPage({super.key});

  @override
  State<AppBarForBanValiPage> createState() => _AppBarForBanValiPageState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _AppBarForBanValiPageState extends State<AppBarForBanValiPage> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    if (appProvider.getAdminInformation == null ||
        appProvider.getSalonInformation == null) {
      return const SizedBox
          .shrink(); // Return empty widget if data is not available
    }

    return AppBar(
      backgroundColor: AppColor.mainColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10,
        ),
        child: Row(
          children: [
            GlobalVariable.samayLogo.isNotEmpty
                // appProvider.getLogImageList.isNotEmpty
                ? Image.asset(
                    GlobalVariable.samayLogo,
                    height: Dimensions.dimenisonNo40,
                    // fit: BoxFit.cover,
                    // loadingBuilder: (context, child, progress) {
                    //   return progress == null
                    //       ? child
                    //       : const Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    // },
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image, // User icon in case of error
                      size: Dimensions
                          .dimenisonNo60, // Set the size of the icon (adjust as needed)
                      color: Colors
                          .grey, // Set the color of the icon (adjust as needed)
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              width: 3,
              height: Dimensions.dimenisonNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Appbaritem(
              text: "Calendar",
              ontap: () {
                // Routes.instance
                //     .push(widget: const HomeScreen(), context: context);
              },
            ),

            SizedBox(width: Dimensions.dimenisonNo20),
            Appbaritem(
              text: "Services",
              ontap: () {
                // Routes.instance.push(widget: ServicesPages(), context: context);
              },
            ),
            const Spacer(),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  // Routes.instance
                  //     .push(widget: SettingsPage(), context: context);
                },
              ),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              width: 3,
              height: Dimensions.dimenisonNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            // SizedBox(width: Dimensions.dimenisonNo16),
            Padding(
              padding: EdgeInsets.all(Dimensions.dimenisonNo20),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  appProvider.getAdminInformation.image ??
                      'https://via.placeholder.com/150',
                ),
                radius: Dimensions.dimenisonNo20,
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image loading error here
                  print("Image load error: $exception");
                },
              ),
            ),

            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appProvider.getAdminInformation.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.dimenisonNo16,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.dimenisonNo5,
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.dimenisonNo12,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
