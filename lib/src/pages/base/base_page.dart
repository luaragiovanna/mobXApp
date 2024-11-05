import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/announcement/create/create_announcement.dart';
import 'package:flutter_box_project/src/pages/home/home_page.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
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

  @override
  void initState() {
    super.initState();
    reaction((_) => pageStore.page, (page) {
      if (pageController.page != page) {
        // Evita chamar se a página já for a mesma
        pageController.jumpToPage(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          HomePage(),
          Container(
            color: Colors.pink.shade200,
          ),
          CreateAnnouncement(),
          Container(
            color: Colors.pink.shade400,
          ),
          Container(
            color: Colors.pink.shade500,
          ),
        ],
      ),
    );
  }
}
