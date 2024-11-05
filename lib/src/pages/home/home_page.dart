import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/pages/home/components/search_dialog.dart';
import 'package:flutter_box_project/src/pages/home/components/top_bar.dart';
import 'package:flutter_box_project/src/stores/home/home_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  final HomeStore homeStore = GetIt.I<HomeStore>();
  HomePage({super.key});
  openSearch(BuildContext context) async {
    final search = await showDialog<String>(
      context: context,
      builder: (_) => SearchDialog(currentSearch: homeStore.search),
    );

    if (search != null && search.isNotEmpty) {
      homeStore.setSearch(search); // Atualiza o estado com o valor da pesquisa
    } else {
      print('Pesquisa cancelada ou sem valor.');
    }

    print('Valor retornado da pesquisa: $search'); // Exibe o valor da pesquisa
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade100,
          title: Observer(
            builder: (_) {
              if (homeStore.search.isEmpty) return Container();
              return GestureDetector(
                onTap: () => openSearch(context),
                child: LayoutBuilder(
                  builder: (_, contraints) {
                    return Container(
                      width: contraints.biggest.width,
                      child: Text(
                        homeStore.search,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            Observer(
              builder: (_) {
                if (homeStore.search.isEmpty) {
                  return IconButton(
                    onPressed: () {
                      openSearch(context);
                    },
                    icon: const Icon(Icons.search),
                  );
                }
                return IconButton(
                    onPressed: () {
                      homeStore.setSearch('');
                    },
                    icon: const Icon(Icons.close));
              },
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            TopBar(),
          ],
        ),
      ),
      
    );
  }
}
