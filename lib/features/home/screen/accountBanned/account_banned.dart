import 'package:flutter/material.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/appbar_ban_vali_page.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class AccountBanPage extends StatelessWidget {
  const AccountBanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBarForBanValiPage(scaffoldKey: _scaffoldKey),
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
                    Icons.block,
                    size: Dimensions.dimensionNo60,
                    color: Colors.red,
                  ),
                  SizedBox(height: Dimensions.dimensionNo16),
                  Text(
                    'Your Account Has Been Banned',
                    style: TextStyle(
                      fontSize: Dimensions.dimensionNo20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.dimensionNo8),
                  Text(
                    'Contact Support for Assistance',
                    style: TextStyle(
                      fontSize: Dimensions.dimensionNo16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.dimensionNo20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📞 Call: 7972391849',
                        style: TextStyle(
                            fontSize: Dimensions.dimensionNo16,
                            color: Colors.black87),
                      ),
                      SizedBox(height: Dimensions.dimensionNo8),
                      Text(
                        '📧 Email: helpquickjet@gmail.com',
                        style: TextStyle(
                            fontSize: Dimensions.dimensionNo16,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.dimensionNo20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Action to redirect or contact support
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.redAccent,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(Dimensions.dimensionNo8),
                  //     ),
                  //   ),
                  //   child: const Text('Contact Support'),
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
