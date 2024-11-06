import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/components/cep/cep_field.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/pages/announcement/components/category/category_field.dart';
import 'package:flutter_box_project/src/pages/announcement/components/images/images_field.dart';
import 'package:flutter_box_project/src/pages/announcement/create/hidephone_field.dart';
import 'package:flutter_box_project/src/pages/category/category_page.dart';
import 'package:flutter_box_project/src/pages/user/myads/my_ads_page.dart';
import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key, required this.ad});

  final Ad ad;

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateAnnouncement> {
  final CreateStore createStore = CreateStore();
  bool editing = false;

  @override
  void initState() {
    super.initState();
    editing = widget.ad != null;

    when((_) => createStore.savedAd, () {
      if (editing)
        Navigator.of(context).pop(true);
      else {
        GetIt.I<PageStore>().setPage(0);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MyAdsPage(initialPage: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.grey,
      fontSize: 18,
    );

    const contentPadding = EdgeInsets.fromLTRB(16, 10, 12, 10);

    return Scaffold(
      drawer: editing ? null : const CustomDrawer(),
      appBar: AppBar(
        title: Text(editing ? 'Editar Anúncio' : 'Criar Anúncio'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Observer(
              builder: (_) {
                if (createStore.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Salvando Anúncio',
                          style: TextStyle(fontSize: 18, color: Colors.purple),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.purple),
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImagesField(createStore: createStore),
                      _buildTextFormField(
                        label: 'Título *',
                        initialValue: createStore.title,
                        onChanged: createStore.setTitle,
                        errorText: createStore.titleError,
                      ),
                      _buildTextFormField(
                        label: 'Descrição *',
                        initialValue: createStore.description,
                        onChanged: createStore.setDescription,
                        errorText: createStore.descriptionError,
                        maxLines: null,
                      ),
                      CategoryField(createStore: createStore),
                      CepField(createStore),
                      _buildTextFormField(
                        label: 'Preço *',
                        initialValue: createStore.priceText,
                        onChanged: createStore.setPrice,
                        errorText: createStore.priceError,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RealInputFormatter(moeda: true),
                        ],
                        prefixText: 'R\$ ',
                      ),
                      HidephoneField(createStore: createStore),
                      Observer(builder: (_) {
                        return ErrorBox(message: createStore.error);
                      }),
                      Observer(builder: (_) {
                        return SizedBox(
                          height: 50,
                          child: GestureDetector(
                            onTap: createStore.invalidSendPressed,
                            child: ElevatedButton(
                              child: const Text(
                                'Enviar',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: createStore.sendPressed,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String? initialValue,
    required Function(String) onChanged,
    String? errorText,
    int? maxLines,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
  }) {
    return Observer(
      builder: (_) {
        return TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              fontSize: 18,
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            errorText: errorText,
            prefixText: prefixText,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        );
      },
    );
  }
}
