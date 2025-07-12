import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/popup/add_new_super_category.dart';
import 'package:samay_admin_plan/features/product/screen/product_add_screen.dart';
import 'package:samay_admin_plan/widget/add_button.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
        // drawer: MobileDrawer(),
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AddButton(
                    text: "Add Brand",
                    onTap: () {
                      Routes.instance
                          .push(widget: ProductAddScreen(), context: context);
                      // Use showDialog to display the AddNewSuperCategory widget
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => const AddNewSuperCategory(),
                      // );
                    },
                  )
                ],
              ),
            ],
          ),
        ))

        // Center(
        //   child: Text(
        //     'Product Screen5555',
        //     style: Theme.of(context).textTheme.headlineMedium,
        //   ),
        // ),
        );
  }
}
