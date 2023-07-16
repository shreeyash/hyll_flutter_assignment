import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_flutter_challenge/screens/launch/launch_view.dart';
import 'package:senior_flutter_challenge/screens/launch/launch_view_model.dart';
import 'package:senior_flutter_challenge/screens/swipe/swipe_view.dart';
import 'package:senior_flutter_challenge/screens/swipe/swipe_view_model.dart';

void main() {
  Get.lazyPut(() => LaunchViewModel());
  Get.lazyPut(() => SwipeViewModel());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hyll Assignment',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LaunchView()),
        GetPage(name: SwipeView.routeName, page: () => SwipeView()),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
