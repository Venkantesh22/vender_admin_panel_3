// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MobileAppBar({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return AppBar(
      backgroundColor: AppColor.mainColor,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  appProvider.getAdminInformation.image ??
                      'https://via.placeholder.com/150',
                ),
                radius: Dimensions.dimensionNo20,
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint("Image load error: $exception");
                },
              ),
              SizedBox(width: Dimensions.dimensionNo10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 2),
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.dimensionNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: Dimensions.dimensionNo12),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
