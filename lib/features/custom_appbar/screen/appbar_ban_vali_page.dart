// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/setting/setting_page.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class AppBarForBanValiPage extends StatefulWidget
    implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppBarForBanValiPage({super.key, required this.scaffoldKey});

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

    return ResponsiveLayout(
        mobile:
            mobileVaildatePageAppBar(context, appProvider, widget.scaffoldKey),
        desktop: webVaildatePageAppBar(context, appProvider));
  }

  AppBar webVaildatePageAppBar(BuildContext context, AppProvider appProvider) {
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
            GlobalVariable.samayLogo.isNotEmpty
                // appProvider.getLogImageList.isNotEmpty
                ? Image.asset(
                    GlobalVariable.samayLogo,
                    height: Dimensions.dimensionNo40,
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
            // SizedBox(width: Dimensions.dimensionNo20),
            // Appbaritem(
            //   text: "Calendar",
            //   ontap: () {
            //     showBottomMessage(
            //         "Please wait for your account to be validated.", context);
            //     // Routes.instance
            //     //     .push(widget: const HomeScreen(), context: context);
            //   },
            // ),

            // SizedBox(width: Dimensions.dimensionNo20),
            // Appbaritem(
            //   text: "Services",
            //   ontap: () {
            //     showBottomMessage(
            //         "Please wait for your account to be validated.", context);
            //     // Routes.instance.push(widget: ServicesPages(), context: context);
            //   },
            // ),
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
                  Routes.instance
                      .push(widget: SettingsPage(), context: context);
                },
              ),
            ),
            SizedBox(width: Dimensions.dimensionNo20),
            Container(
              width: 3,
              height: Dimensions.dimensionNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            // SizedBox(width: Dimensions.dimensionNo16),
            Padding(
              padding: EdgeInsets.all(Dimensions.dimensionNo20),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  appProvider.getAdminInformation.image ??
                      'https://via.placeholder.com/150',
                ),
                radius: Dimensions.dimensionNo20,
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
                        fontSize: Dimensions.dimensionNo16,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
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
          ],
        ),
      ),
    );
  }

  AppBar mobileVaildatePageAppBar(BuildContext context, AppProvider appProvider,
      GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      backgroundColor: AppColor.mainColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: IconButton(
        icon: GlobalVariable.samayLogo.isNotEmpty
            ? Image.asset(
                GlobalVariable.samayLogo,
                height: Dimensions.dimensionNo30,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  size: Dimensions.dimensionNo30,
                  color: Colors.grey,
                ),
              )
            : const CircularProgressIndicator(),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.settings_outlined, color: Colors.black),
                  onPressed: () {
                    Routes.instance
                        .push(widget: SettingsPage(), context: context);
                  },
                ),
              ),
              SizedBox(width: Dimensions.dimensionNo20),
              Container(
                width: 3,
                height: Dimensions.dimensionNo40,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              // SizedBox(width: Dimensions.dimensionNo16),
              Container(
                padding: EdgeInsets.all(6),

                clipBehavior: Clip.antiAlias,
                width: Dimensions.dimensionNo50 * 2, // Diameter of the circle
                height: Dimensions.dimensionNo50 * 2, // Diameter of the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      appProvider.getAdminInformation.image ??
                          'https://via.placeholder.com/150',
                    ),
                    fit: BoxFit.cover, // Ensures the image fits the circle
                    onError: (exception, stackTrace) {
                      // Handle image loading error here
                      print("Image load error: $exception");
                    },
                  ),
                ),
              ),

              SizedBox(
                width: Dimensions.screenWidthM / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      appProvider.getAdminInformation.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.dimensionNo14,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 2,
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
              ),
            ],
          ),
        ),
        SizedBox(width: Dimensions.dimensionNo12),
      ],
    );
  }
}
