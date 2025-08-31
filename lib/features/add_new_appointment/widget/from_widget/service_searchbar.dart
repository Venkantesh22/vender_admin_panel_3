import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_appoint.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

Widget serviceSearchBar(
  SearchController controller,
  BuildContext context,
  BookingProvider bookingProvider,
  List<ServiceModel> allServiceList,
) {
  return SizedBox(
    width:
        ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Service",
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo14
                : Dimensions.dimensionNo18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.dimensionNo5),
        SearchAnchor(
          searchController: controller,
          builder: (context, searchController) => SizedBox(
            height: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimensionNo35
                : Dimensions.dimensionNo40,
            width: ResponsiveLayout.isMobile(context)
                ? null
                : Dimensions.dimensionNo250,
            child: SearchBar(
              controller: searchController,
              hintText: "Search Service...",
              side: WidgetStateProperty.all(
                  const BorderSide(width: 1, color: Colors.black)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: Dimensions.dimensionNo10,
                  vertical: Dimensions.dimensionNo10,
                ),
              ),
              elevation: WidgetStateProperty.all(0),
              onTap: () {
                // 👇 important: open the suggestion view
                searchController.openView();
              },
              onChanged: (_) {
                // 👇 also reopen view while typing
                if (!searchController.isOpen) {
                  searchController.openView();
                }
              },
            ),
          ),
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            if (query.isEmpty) return [];

            final results = allServiceList
                .where((element) =>
                    element.servicesName
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element.serviceCode.contains(query))
                .toList();

            return results.map((service) {
              return serviceTapAddRemoveButton(service, context);
            });
          },
        ),
      ],
    ),
  );
}
