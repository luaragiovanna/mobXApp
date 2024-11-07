import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/models/category/category_model.dart';
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
  final PageController pageController = PageController();
  final PageStore pageStore = GetIt.I<PageStore>();
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();
  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  @override
  void initState() {
    super.initState();

    reaction((_) => pageStore.page, (page) => pageController.jumpToPage(page));

    autorun((_) {
      if (!connectivityStore.connected) {
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          showDialog(context: context, builder: (_) => OfflinePage());
        });
      }
    });

    // Debugging: Print user status
    print("Usuário logado: ${userManagerStore.user}");
    print("isLoggedIn: ${userManagerStore.isLoggedIn}");
  }

  @override
  Widget build(BuildContext context) {
    // Debugging: Print novamente antes de instanciar CreateAnnouncement
    print(
        "Verificando status do usuário antes de instanciar CreateAnnouncement...");
    print("isLoggedIn: ${userManagerStore.isLoggedIn}");
    print("User: ${userManagerStore.user}");

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          userManagerStore.isLoggedIn
              ? CreateAnnouncement(
                  ad: Ad(
                    user: userManagerStore.user!,
                    images: [],
                    category: CategoryModel(id: '', description: '', name: ''),
                    price: 0,
                    hidePhone: false,
                    createdAt: DateTime.now(),
                  ),
                )
              : Center(
                  child: Text("Por favor, faça login para criar um anúncio"),
                ),
          ChatRoomPage(),
          FavoritePage(),
          AccountScreen(),
        ],
      ),
    );
  }
}
