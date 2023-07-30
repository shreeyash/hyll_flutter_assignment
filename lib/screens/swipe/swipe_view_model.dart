import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:senior_flutter_challenge/api_service/apis_path.dart';
import 'package:senior_flutter_challenge/data/models/hyll_adventures_model.dart';
import 'package:senior_flutter_challenge/data/repository/adventure_repo.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeViewModel extends GetxController {
  final Logger logger = Logger();
  final List<SwipeItem> swipeItems = <SwipeItem>[];
  late MatchEngine matchEngine;
  Rx<HyllAdventuresModel> hyllAdventuresModel = HyllAdventuresModel().obs;

  RxBool isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    String initialUrl = ApiPaths.adventureApiInitialPath;
    getAventuresList(initialUrl);
  }

  //Get adventures list
  Future<void> getAventuresList(String url) async {
    isLoading.value = true;
    logger.d("getAventuresList");
    try {
      hyllAdventuresModel.value =
          await AdventureRepository.getAdventures(nextUrl: url);
    } catch (e) {
      logger.e(e.toString());
      Get.rawSnackbar(
        snackStyle: SnackStyle.GROUNDED,
        message: "Unable to load data, please try again later.",
        duration: Duration(milliseconds: 1200),
        backgroundColor: Colors.yellow,
      );
    }
    initSwipeIteams();
    logger.d(hyllAdventuresModel);

    isLoading.value = false;
  }

  //Init swipe items
  initSwipeIteams() {
    if (hyllAdventuresModel.value.data == null) return;
    for (int i = 0; i < hyllAdventuresModel.value.data!.length; i++) {
      swipeItems.add(SwipeItem(
          content: hyllAdventuresModel.value.data![i],
          likeAction: () {
            Get.rawSnackbar(
              snackStyle: SnackStyle.GROUNDED,
              message: "Saved \"${hyllAdventuresModel.value.data![i].title}\"",
              duration: Duration(milliseconds: 800),
              backgroundColor: Colors.green,
            );
          },
          nopeAction: () {
            Get.rawSnackbar(
              snackStyle: SnackStyle.GROUNDED,
              message: "Nope \"${hyllAdventuresModel.value.data![i].title}\"",
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 800),
            );
          },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }
    matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  //Fetches next stack of adventures
  nextStack() async {
    isLoading.value = true;
    logger.d("nextStack");
    String nextUrl = hyllAdventuresModel.value.next ?? "";
    if (nextUrl.isEmpty) {
      Get.rawSnackbar(
        snackStyle: SnackStyle.GROUNDED,
        message: "No new adventures",
        duration: Duration(milliseconds: 1200),
        backgroundColor: Colors.orange,
      );
      isLoading.value = false;
      return;
    }
    hyllAdventuresModel.value = HyllAdventuresModel();
    swipeItems.clear();
    await getAventuresList(nextUrl);
    isLoading.value = false;
  }

  //speudo code to keep track of liked adventures where we save the tags of liked adventures
  //and then we can use them to filter the adventures list
  // List<String> likedAdventures = [];

  //savedTags(int index){
  //  likedAdventures.add(hyllAdventuresModel.value.data![index].tags);
  // post the likedAdventures to the server
  // get updated adventures list
  // print(likedAdventures);
  //}

  // preventing dubilication adventures in the list
  // keep track of the adventures that we already swiped in cache or user-preferance

}
