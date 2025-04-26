// Placeholder for the "Admin" page
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/models/admin_model/admin_models.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  Uint8List? selectedImage;
  bool _isLoading = false;
  bool _isupdate = false;
  bool _isImageChange = false;

  chooseImages() async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      selectedImage = chosenImageFile!.files.single.bytes;
      _isImageChange = true;
    });
  }

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
      _nameController.text = appProvider.getAdminInformation.name;
      _mobileController.text =
          appProvider.getAdminInformation.number.toString();
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? CircularProgressIndicator()
          : Container(
              color: AppColor.bgForAdminCreateSec,
              child: Center(
                child: Container(
                  margin: ResponsiveLayout.isMobile(context)
                      ? EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo12,
                        )
                      : ResponsiveLayout.isTablet(context)
                          ? EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo60,
                            )
                          : null,
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimenisonNo10
                          : Dimensions.dimenisonNo30,
                      vertical: Dimensions.dimenisonNo20),
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
                          'Admin Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo36,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo10),
                        child: Divider(),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Upload admin Images ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.dimenisonNo18,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.15,
                              ),
                            ),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: const Color(0xFFFC0000),
                                fontSize: Dimensions.dimenisonNo18,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.dimenisonNo10),
                      Center(
                        child: selectedImage == null
                            ? InkWell(
                                onTap: () {
                                  chooseImages();
                                  // print("icon $selectedImage");
                                },
                                child: Container(
                                  width: Dimensions.dimenisonNo70,
                                  height: Dimensions.dimenisonNo70,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: Dimensions.dimenisonNo35,
                                    child:
                                        appProvider.getAdminInformation.image !=
                                                null
                                            ? Image.network(
                                                appProvider
                                                    .getAdminInformation.image!,
                                                fit: BoxFit
                                                    .cover, // Change BoxFit.fill to BoxFit.cover
                                              )
                                            : Icon(
                                                Icons.camera_alt,
                                                size: Dimensions.dimenisonNo200,
                                              ),
                                  ),
                                ))
                            : InkWell(
                                onTap: () {
                                  chooseImages();
                                  // print("image $selectedImage");
                                },
                                child: Container(
                                  width: Dimensions.dimenisonNo70,
                                  height: Dimensions.dimenisonNo70,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Image.memory(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo12),
                        child: Center(
                          child: Text(
                            appProvider.getAdminInformation.email,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.dimenisonNo10),
                      FormCustomTextField(
                        controller: _nameController,
                        title: "Admin Name",
                      ),
                      SizedBox(height: Dimensions.dimenisonNo10),
                      FormCustomTextField(
                        controller: _mobileController,
                        title: "Mobile No",
                      ),
                      SizedBox(height: Dimensions.dimenisonNo20),
                      CustomAuthButton(
                        text: "Update",
                        ontap: () async {
                          try {
                            bool _isVaildated = adminUpdateVaildation(
                              _nameController.text,
                              _mobileController.text,
                              selectedImage!,
                            );

                            if (_isVaildated) {
                              AdminModel adminModelUpdate =
                                  appProvider.getAdminInformation.copyWith(
                                name: _nameController.text.trim(),
                                number:
                                    int.parse(_mobileController.text.trim()),
                              );

                              _isImageChange
                                  ? _isupdate =
                                      await appProvider.updateAdminInfoPro(
                                          context, adminModelUpdate,
                                          image: selectedImage)
                                  : _isupdate =
                                      await appProvider.updateAdminInfoPro(
                                          context, adminModelUpdate,
                                          image: selectedImage);

                              showMessage("Admin Update Successfully add");
                              // print("Salon ID ${GlobalVariable.salonID}");

                              if (_isupdate) {
                                Routes.instance.push(
                                    widget: HomeScreen(
                                      date: Provider.of<CalenderProvider>(
                                              context,
                                              listen: false)
                                          .getSelectDate,
                                    ),
                                    context: context);
                              }
                            }
                          } catch (e) {
                            print(e.toString());
                            showMessage(
                                'Salon is not Update or an error occurred');
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
