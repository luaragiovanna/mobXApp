import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/login/login_page.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';

class CustomDrawerHeader extends StatelessWidget {
  final UserManagerStore userManagerStore =
      GetIt.I<UserManagerStore>(); //trazendo pra var userManagesore
  CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    userManagerStore.user; //acessar o usuario logado
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); //drawer n fika aberto
        if (userManagerStore.isLoggedIn) {
          GetIt.I<PageStore>().setPage(4);
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => LoginPage()));
        }
      },
      child: Container(
        color: Colors.pink.shade200,
        height: 95,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userManagerStore.isLoggedIn
                        ? userManagerStore.user!.name.toString()
                        : 'Entrar?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    userManagerStore.isLoggedIn
                        ? userManagerStore.user!.email
                        : 'Clique aqui',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
