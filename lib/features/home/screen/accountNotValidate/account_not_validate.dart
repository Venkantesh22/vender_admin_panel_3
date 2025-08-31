import 'package:flutter/material.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/appbar_ban_vali_page.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class AccountNotValidatePage extends StatelessWidget {
  const AccountNotValidatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBarForBanValiPage(scaffoldKey: scaffoldKey),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.dimensionNo16),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
            ),
            child: Container(
              padding: EdgeInsets.all(Dimensions.dimensionNo16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: Dimensions.dimensionNo60,
                    color: Colors.green,
                  ),
                  SizedBox(height: Dimensions.dimensionNo16),
                  Text(
                    'Salon Created Successfully!',
                    style: TextStyle(
                      fontSize: Dimensions.dimensionNo20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: Dimensions.dimensionNo8),
                  Text(
                    'However, it is not validated by Samay.',
                    style: TextStyle(
                      fontSize: Dimensions.dimensionNo16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.dimensionNo8),
                  Text(
                    'Please wait for the validation.',
                    style: TextStyle(
                      fontSize: Dimensions.dimensionNo16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Action to redirect or refresh the page
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.teal,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   child: const Text('Go Back'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
