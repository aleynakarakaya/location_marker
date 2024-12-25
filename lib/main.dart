import 'package:flutter/material.dart';
import 'package:location_marker/config/constants.dart';
import 'package:location_marker/view/location_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        fontFamily: StringConstants.asapRegular,
      ),
      home: LocationPage(),
    );
  }
}