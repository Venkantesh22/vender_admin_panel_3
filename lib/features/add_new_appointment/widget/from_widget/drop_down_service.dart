import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/validation.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/dropdownlist/dopdownlist.dart';


  // DropdownList select Service at home or Salon
  // Default value is Salon
Widget dropDownListSelectServiceAt(
  String serviceAt,
  List<String> serviceAtList,
  BuildContext context,
  Function(dynamic) onChanged,
) {
  return SizedBox(
    width:
        ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
    child: dropDownList(
      heading: "Select service at",
      value: serviceAt,
      labelText: "Service at",
      valueList: serviceAtList,
      validator: noValidator,
      onChanged: onChanged,

     
    ),
  );
}
