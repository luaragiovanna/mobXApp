import 'package:flutter/material.dart';
import 'package:flutter_box_project/src/pages/base/base_page.dart';

import 'package:flutter_box_project/src/pages/home/filter/filter_page.dart';

import 'package:flutter_box_project/src/repositories/ibge_api/cep_repository.dart';

import 'package:flutter_box_project/src/stores/category/category_store.dart';
import 'package:flutter_box_project/src/stores/connectivity/connectivity_store.dart';
import 'package:flutter_box_project/src/stores/home/filter/filter_store.dart';
import 'package:flutter_box_project/src/stores/home/home_store.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_box_project/src/stores/user/favorite_store.dart';
import 'package:flutter_box_project/src/stores/user/user_manager_store.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  //OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  //OneSignal.initialize("81280b13-f804-4870-8edd-91c0eb8c591a");
  //OneSignal.Notifications.requestPermission(true);

  WidgetsFlutterBinding.ensureInitialized();
  await initializeParse(); //so roda quando initializa o parse
  setupLocators();
  runApp(const MyApp());
  //CepRepository().getAddressFromApi('85035-160').toString();
}
// await Parse().initialize('NhSkVJlp660WvEpFrv4V9xt4rqB1E6ELMJ9eCdMm',
//     'https://parseapi.back4app.com',
//     clientKey: '18LF7aeWL8upxXwaa726SgFv5plwGPyNjm0OjBwQ',
//     autoSendSessionId: true,
//     debug: true);
//   //parse object um registro de um campo
//   //final objetoX = ParseObject('TABELAX');
//   final category = ParseObject('Categories')
//     ..set<String>('Title', 'Meias')
//     ..set<int>('Position', 1);

//   //setando objeto
//   //enviando objeto pro back4app objetoX.save();
//   final response = await category.save();
//   //response agr tem indo sobre salvamento
//   // print(response.results);
//   // print(response.success);
//lendo 1 obj
// final response = await ParseObject('Categories').getObject('eRCHmVrZny');
// if (response.success) {
//   print(response.results);
// }
//lendo todos objetos de uma classe
// final response = await ParseObject('Categories').getAll();
// if (response.success) {
//   for (final object in response.result) {
//     print(object);
//   }
// }

// final query = QueryBuilder(ParseObject('Categories'));
// query.whereContains('Title', 'Meias');

Future<void> initializeParse() async {
  await Parse().initialize('NhSkVJlp660WvEpFrv4V9xt4rqB1E6ELMJ9eCdMm',
      'https://parseapi.back4app.com',
      clientKey: '18LF7aeWL8upxXwaa726SgFv5plwGPyNjm0OjBwQ',
      autoSendSessionId: true,
      debug: true);
}

void setupLocators() {
  GetIt.I.registerSingleton(ConnectivityStore());
  GetIt.I.registerSingleton(
      UserManagerStore()); //instancia acessivel de qualquer parte do app
  //get it -> localizar servicos do app
  GetIt.I.registerSingleton(CategoryStore());
  GetIt.I.registerSingleton(HomeStore());
  GetIt.I.registerSingleton(FilterStore());
  GetIt.I.registerSingleton(PageStore()); //obter de qualquer local do app
  GetIt.I.registerSingleton(FavoriteStore());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'XLO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: BasePage());
  }
}
