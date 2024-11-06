import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
import 'package:flutter_box_project/src/models/user/user_model.dart';
import 'package:flutter_box_project/src/pages/announcement/create/create_announcement.dart';
import 'package:flutter_box_project/src/pages/chat/chat_room_page.dart';
import 'package:flutter_box_project/src/pages/edit_account/account_page.dart';
import 'package:flutter_box_project/src/pages/edit_account/favorite/favorite_page.dart';
import 'package:flutter_box_project/src/pages/home/home_page.dart';
import 'package:flutter_box_project/src/pages/offline/offline_page.dart';
import 'package:flutter_box_project/src/stores/connectivity/connectivity_store.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class BasePage extends StatefulWidget {
  BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //mudar a pagina atraves de controller
  final PageController pageController = PageController();

  final PageStore pageStore = GetIt.I<PageStore>();
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  @override
  void initState() {
    super.initState();

    reaction((_) => pageStore.page, (page) => pageController.jumpToPage(page));

    autorun((_) {
      print(connectivityStore.connected);
      if (!connectivityStore.connected) {
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          showDialog(context: context, builder: (_) => OfflinePage());
        });
      }
    });
  }

  Ad createDummyAd() {
    return Ad(
      user: UserModel(
          name: '',
          email: '',
          phone: '',
          id: '',
          createdAt: DateTime.now()), // You can pass a mock UserModel if needed
      images: ObservableList<String>.of(
          ['https://placekitten.com/200/200']), // Add at least one image
      id: 'dummyId', // Pass any string for ID
      title: 'Sample Ad', // Provide a title for the ad
      description: 'This is a sample ad description.', // Provide a description
      category: CategoryModel(
          name: 'Sample Category',
          id: 'sampleId',
          description: ''), // Create a dummy category
      price: 99.99, // Pass any number for price
      createdDate: DateTime.now(), // Use current date or any date
      hidePhone: false, // Assuming hidePhone is a boolean
      views: 0, // You can start with zero views
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          CreateAnnouncement(
            ad: createDummyAd(),
          ),
          ChatRoomPage(),
          FavoritePage(),
          AccountScreen()
          // AccountScreen(),
        ],
      ),
    );
  }
}
