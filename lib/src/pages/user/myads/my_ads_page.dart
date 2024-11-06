import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/card/empty_card.dart';
import 'package:flutter_box_project/src/pages/user/myads/components/active_tile.dart';
import 'package:flutter_box_project/src/pages/user/myads/components/pending_tile.dart';
import 'package:flutter_box_project/src/pages/user/myads/components/sold_tile.dart';
import 'package:flutter_box_project/src/stores/user/my_ads_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MyAdsPage extends StatefulWidget {
  final int initialPage;
  const MyAdsPage({super.key, this.initialPage = 0});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> with SingleTickerProviderStateMixin {
  final MyAdsStore store = MyAdsStore(); //passa store no soldTile

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Anúncios'),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(child: Text('ATIVOS')),
            Tab(child: Text('PENDENTES')),
            Tab(child: Text('VENDIDOS')),
          ],
        ),
      ),
      body: Observer(
        builder: (_) {
          if (store.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          }
          return TabBarView(
            controller: tabController,
            children: [
              Observer(
                builder: (_) {
                  if (store.activeAds.isEmpty) {
                    return Text('Você não possui nenhum anúncio ativo.');
                  }

                  return ListView.builder(
                    itemCount: store.activeAds.length,
                    itemBuilder: (_, index) {
                      return ActiveTile(store.activeAds[index], store); //mandar a store
                    },
                  );
                },
              ),
              Observer(
                builder: (_) {
                  if (store.pendingAds.isEmpty) {
                    return const EmptyCard(text: 'Voce não possui nenhum anuncio ativo',);
                  }

                  return ListView.builder(
                    itemCount: store.pendingAds.length,
                    itemBuilder: (_, index) {
                      return ActiveTile(store.pendingAds[index], store);
                    },
                  );
                },
              ),
              Observer(
                builder: (_) {
                  if (store.soldAds.isEmpty) {
                    return const EmptyCard(text: 'Você não possui nenhum anúncio vendido',);
                  }

                  return ListView.builder(
                    itemCount: store.soldAds.length,
                    itemBuilder: (_, index) { 
                      return SoldTile(store.soldAds[index], store);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
