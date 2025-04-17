// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';

// class MyEx extends StatelessWidget {
//   const MyEx({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     return Scaffold(
//       // appBar: PreferredSize(
//       //   preferredSize: Size.fromHeight(60.0),
//       //   child: CustomAppBar(),
//       // ),
//       body: Center(
//         child: Column(
//           children: [
//             Text("hii"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Pending = 1
// Confirmed = 2
// InProcess = 3
// Completed = 4