import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/custom_appbar/widget/appbar_item.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class LoadAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LoadAppBar({super.key});

  @override
  State<LoadAppBar> createState() => _LoadAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _LoadAppBarState extends State<LoadAppBar> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppBar(
      backgroundColor: AppColor.mainColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimensionNo10,
          vertical: Dimensions.dimensionNo10,
        ),
        child: Row(
          children: [
            // Image.asset(
            //   AppImages.logo,
            //   height: Dimensions.dimensionNo40,
            // ),
            GlobalVariable.samayLogo.isNotEmpty
                // appProvider.getLogImageList.isNotEmpty
                ? Image.asset(
                    GlobalVariable.samayLogo,
                    height: Dimensions.dimensionNo40,
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
                          .dimensionNo60, // Set the size of the icon (adjust as needed)
                      color: Colors
                          .grey, // Set the color of the icon (adjust as needed)
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            SizedBox(width: Dimensions.dimensionNo20),
            Container(
              width: 3,
              height: Dimensions.dimensionNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            SizedBox(width: Dimensions.dimensionNo20),
            Appbaritem(
              text: "Calendar",
              ontap: () {
                Routes.instance.push(
                    widget: HomeScreen(
                      date:
                          Provider.of<CalenderProvider>(context, listen: false)
                              .getSelectDate,
                    ),
                    context: context);
              },
            ),

            SizedBox(width: Dimensions.dimensionNo20),
            Appbaritem(
              text: "Services",
              ontap: () {
                // Routes.instance.push(widget: ServicesPages(), context: context);
              },
            ),
            const Spacer(),
            SizedBox(width: Dimensions.dimensionNo20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  // Routes.instance
                  //     .push(widget: ServicesPages(), context: context);
                },
              ),
            ),
            SizedBox(width: Dimensions.dimensionNo20),
            Container(
              width: 3,
              height: Dimensions.dimensionNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            SizedBox(width: Dimensions.dimensionNo20),
            Padding(
              padding: EdgeInsets.all(Dimensions.dimensionNo20),
              child: CircleAvatar(
                radius: Dimensions.dimensionNo20,
                child: SizedBox(
                  height: Dimensions.dimensionNo20,
                  width: Dimensions.dimensionNo20,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
            SizedBox(width: Dimensions.dimensionNo20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimensions.dimensionNo20,
                  width: Dimensions.dimensionNo20,
                  child: const CircularProgressIndicator(),
                ),
                SizedBox(
                  height: Dimensions.dimensionNo5,
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.dimensionNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
