import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/theame.dart';
import 'package:samay_admin_plan/features/home/screen/loading_home_page/loading_home_page.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_list.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/firebase_options.dart';
import 'package:samay_admin_plan/features/auth/login.dart';
import 'package:samay_admin_plan/pitc.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/provider/payment_provider.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/provider/report_provider.dart';
import 'package:samay_admin_plan/provider/samay_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/provider/setting_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),
        ChangeNotifierProvider(create: (context) => CalenderProvider()),
        ChangeNotifierProvider(create: (context) => SettingProvider()),
        ChangeNotifierProvider(create: (context) => EditProvider()),
        ChangeNotifierProvider(create: (context) => SamayProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Salon Samay',
          theme: themeData,
          home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              Dimensions.init(context); // Initialize dimensions
              // if (snapshot.hasData) {
              //   return const LoadingHomePage(); // Direct to LoadingHomePage if user is authenticated
              // }
              // return const LoginScreen(); // Show LoginScreen if user is not authenticated
              return SamayPitchDeck();
            },
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/services_list') {
              final args =
                  settings.arguments as String; // Pass arguments if needed
              return MaterialPageRoute(
                builder: (context) => ServicesList(superCategoryName: args),
              );
            } else if (settings.name == '/services_page') {
              return MaterialPageRoute(
                builder: (context) => const ServicesPages(),
              );
            }
            return null; // Return null for undefined routes
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(child: Text('Page not found')),
              ),
            );
          },
        );
      },
    );
  }
}
