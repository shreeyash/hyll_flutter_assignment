import 'package:get/get.dart';
import 'package:senior_flutter_challenge/screens/swipe/swipe_view.dart';

class LaunchViewModel extends GetxController {
  @override
  bool get initialized => super.initialized;

  onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 2), () {
      navigateToSwipeView();
    });
  }

  navigateToSwipeView() {
    Get.offAndToNamed(SwipeView.routeName);
  }
}
