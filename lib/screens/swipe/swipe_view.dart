import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:senior_flutter_challenge/screens/swipe/swipe_view_model.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeView extends StatefulWidget {
  static const String routeName = "/swipe";
  const SwipeView({super.key});

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  final SwipeViewModel swipeViewModel = Get.find();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    swipeViewModel.matchEngine =
        MatchEngine(swipeItems: swipeViewModel.swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 1,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "HYLL",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedLabelStyle:
            const TextStyle(color: Colors.black, fontSize: 14),
        backgroundColor: Colors.black,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
              color: Colors.black,
            ),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              color: Colors.black,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.black,
              size: 35,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.black,
            ),
            label: "Plans",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: Obx(
        () => swipeViewModel.isLoading.value
            ? const LodingAdventures()
            : SwipeCardsSection(
                matchEngine: swipeViewModel.matchEngine,
                swipeItems: swipeViewModel.swipeItems),
        // LodingAdventures(),
      ),
    );
  }
}

class LodingAdventures extends StatelessWidget {
  const LodingAdventures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,
                colors: const [
                  Color(0xff5A5FFE),
                  Color(0xff6B6FFD),
                  Color(0xff9A99FD),
                  Color(0xffD4CFFE),
                ],
                strokeWidth: 1,
                backgroundColor: Colors.white,
                pathBackgroundColor: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 400.0),
            child: Text(
              "Looking for the best adventures...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SwipeCardsSection extends StatelessWidget {
  SwipeCardsSection({
    super.key,
    required MatchEngine matchEngine,
    required List<SwipeItem> swipeItems,
  })  : _matchEngine = matchEngine,
        _swipeItems = swipeItems;

  final MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems;

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    SwipeViewModel swipeViewModel = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              return Obx(
                () => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        swipeViewModel.hyllAdventuresModel.value.data?[index]
                                .contents?[0].contentUrl ??
                            "",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _swipeItems[index].content.title,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onStackFinished: () {
              logger.d("stack finished");
              swipeViewModel.nextStack();
            },
            itemChanged: (SwipeItem item, int index) {
              logger.d("item: ${item.content.id}, index: $index");
            },
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}
