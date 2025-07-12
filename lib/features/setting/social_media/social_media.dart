import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/salon_social_media_add.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';

class SocialMediaPage extends StatefulWidget {
  const SocialMediaPage({super.key});

  @override
  State<SocialMediaPage> createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _googleMap = TextEditingController();
  final TextEditingController _linked = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      _instagram.text = appProvider.getSalonInformation.instagram!;
      _facebook.text = appProvider.getSalonInformation.facebook!;
      _googleMap.text = appProvider.getSalonInformation.googleMap!;
      _linked.text = appProvider.getSalonInformation.linked!;
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _instagram.dispose();
    _facebook.dispose();
    _googleMap.dispose();
    _linked.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? const CircularProgressIndicator()
          : Container(
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
                        child: Text(
                          'Social media Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? Dimensions.dimensionNo28
                                : Dimensions.dimensionNo36,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimensionNo10),
                        child: Divider(),
                      ),
                      SizedBox(height: Dimensions.dimensionNo10),
                      Text(
                        'Enter Social media link',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimensionNo16,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          letterSpacing: 0.15,
                        ),
                      ),
                      SizedBox(height: Dimensions.dimensionNo10),
                      Column(
                        children: [
                          SalonSocialMediaAdd(
                            text: "Instagram",
                            icon: FontAwesomeIcons.instagram,
                            controller: _instagram,
                          ),
                          SalonSocialMediaAdd(
                            text: "Facebook",
                            icon: FontAwesomeIcons.facebook,
                            controller: _facebook,
                          ),
                          SalonSocialMediaAdd(
                            text: "GoogleMap",
                            icon: FontAwesomeIcons.mapLocationDot,
                            controller: _googleMap,
                          ),
                          SalonSocialMediaAdd(
                            text: "Linked",
                            icon: FontAwesomeIcons.linkedin,
                            controller: _linked,
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.dimensionNo10),
                      CustomAuthButton(
                        text: "Update",
                        ontap: () async {
                          try {
                            // if (_isVaildated) {
                            SalonModel salonModelUpdate =
                                appProvider.getSalonInformation.copyWith(
                              instagram: _instagram.text.isEmpty
                                  ? appProvider.getSalonInformation.instagram
                                  : _instagram.text.trim(),
                              facebook: _facebook.text.isEmpty
                                  ? appProvider.getSalonInformation.facebook
                                  : _facebook.text.trim(),
                              googleMap: _googleMap.text.isEmpty
                                  ? appProvider.getSalonInformation.googleMap
                                  : _googleMap.text.trim(),
                              linked: _linked.text.isEmpty
                                  ? appProvider.getSalonInformation.linked
                                  : _linked.text.trim(),
                            );
                            await appProvider.updateSalonInfoFirebase(
                              context,
                              salonModelUpdate,
                            );

                            showMessage(
                                "Social media Link Update Successfully");
                            print("Salon ID ${GlobalVariable.salonID}");
                          } catch (e) {
                            print(e.toString());
                            showMessage(
                                'Social media Link not Update or an error occurred');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
