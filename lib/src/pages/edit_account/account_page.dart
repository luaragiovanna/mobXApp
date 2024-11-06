import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/pages/edit_account/edit_account_screen.dart';
import 'package:flutter_box_project/src/pages/edit_account/favorite/favorite_page.dart';
import 'package:flutter_box_project/src/pages/user/myads/my_ads_page.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Conta'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Observer(builder: (_) {
                            return Text(
                              GetIt.I<UserManagerStore>().user!.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.purple,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          }),
                          Text(
                            GetIt.I<UserManagerStore>().user!.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        child: Text('EDITAR'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EditAccountScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Meus anúncios',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MyAdsPage()));
                },
              ),
              ListTile(
                title: const Text(
                  'Favoritos',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FavoritePage(
                            hideDrawer: true,
                          ))); //esconde drawer caso abra pela conta
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
