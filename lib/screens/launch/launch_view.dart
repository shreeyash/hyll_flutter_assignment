import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './launch_view_model.dart';

class LaunchView extends StatelessWidget {
  const LaunchView({super.key});

  @override
  Widget build(BuildContext context) {
    final LaunchViewModel launchViewModel = Get.find();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset("./assets/launch.png", fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
