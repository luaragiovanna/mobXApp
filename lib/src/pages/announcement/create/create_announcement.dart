import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/components/cep/cep_field.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/pages/announcement/components/category/category_field.dart';
import 'package:flutter_box_project/src/pages/announcement/components/images/images_field.dart';
import 'package:flutter_box_project/src/pages/announcement/create/hidephone_field.dart';
import 'package:flutter_box_project/src/pages/category/category_page.dart';
import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class CreateAnnouncement extends StatefulWidget {
  CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final CreateStore createStore = CreateStore();

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(100, 158, 117, 132),
        fontSize: 18);
    const contentPadding = EdgeInsets.fromLTRB(16, 10, 12, 10);

    @override
    void initState() {
      super.initState();
      when((_) => createStore.savedAd, () {
        GetIt.I<PageStore>().setPage(0); //navegando p/ pag inicial
      });
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: const Text(
          'Criar anúncio',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Wrap(
          children: [
            SingleChildScrollView(
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Observer(
                  builder: (_) {
                    if (createStore.loading) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Salvando anuncio',
                              style: TextStyle(color: Colors.pink),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.pink),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImagesField(createStore: createStore),
                          Observer(builder: (_) {
                            return TextFormField(
                              onChanged: createStore.setTitle,
                              decoration: InputDecoration(
                                  contentPadding: contentPadding,
                                  labelText: 'Título do seu anúncio',
                                  labelStyle: labelStyle,
                                  errorText: createStore.titleError),
                            );
                          }),
                          CategoryField(
                            createStore: createStore,
                          ), //createStore
                          Observer(builder: (_) {
                            return TextFormField(
                              onChanged: createStore.setDescription,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                labelText: 'Descrição do seu anúncio',
                                labelStyle: labelStyle,
                                errorText: createStore.descriptionError,
                              ),
                              maxLines: null,
                            );
                          }),
                          //CEP FIELD Q TA DANDO PROBLEMA
                          Observer(builder: (_) {
                            return TextFormField(
                              onChanged: createStore.setPrice,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                labelText: 'Preço',
                                labelStyle: labelStyle,
                                errorText: createStore.priceError,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                RealInputFormatter(moeda: true),
                              ],
                            );
                          }),
                          HidephoneField(
                            createStore: createStore,
                          ),
                          ErrorBox(message: createStore.error),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Observer(
                              builder: (_) {
                                return GestureDetector(
                                  onTap: createStore.invalidSendPressed,
                                  child: SizedBox(
                                    height: 50,
                                    child: Observer(
                                      builder: (_) {
                                        return ElevatedButton(
                                          onPressed: createStore.sendPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.pink.shade100,
                                            disabledBackgroundColor: Colors
                                                .pink.shade100
                                                .withAlpha(100),
                                          ),
                                          child: const Text(
                                            'Enviar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
