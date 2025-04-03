import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_share_app/route/route.dart';
import 'package:location_share_app/screens/loading.dart';
import 'package:location_share_app/src/controllers/auth.dart';
import 'package:location_share_app/src/utils/colors.dart';
import 'package:location_share_app/src/utils/snackbar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Share Location',
      navigatorKey: Get.key,
      scaffoldMessengerKey: SnackBarController.scaffoldMessengerKey,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: kMainRed)),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      getPages: getPages,
      initialRoute: LoadingScreen.routeName,
    );
  }
}
