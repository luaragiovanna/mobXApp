import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/components/drawer/custom_drawer.dart';
import 'package:flutter_box_project/src/components/error/error_box.dart';
import 'package:flutter_box_project/src/models/ad/ad.dart';
import 'package:flutter_box_project/src/pages/announcement/components/images/images_field.dart';
import 'package:flutter_box_project/src/pages/announcement/create/hidephone_field.dart';
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
  // ignore: library_private_types_in_public_api
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateAnnouncement> {
  final CreateStore createStore = CreateStore();
  bool editing = false;

  @override
  void initState() {
    super.initState();
    editing = widget.ad != null;

    // Inicialize o CreateStore com os valores do anúncio caso esteja editando
    if (editing) {
      createStore.setTitle(widget.ad.title!);
      createStore.setDescription(widget.ad.description!);
      createStore.setPrice(widget.ad.price.toString());
      createStore.setCategory(widget.ad.category);
      createStore.images.addAll(widget.ad.images);
    }

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

    const contentPadding = EdgeInsets.fromLTRB(10, 10, 12, 10);

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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            color: const Color.fromARGB(255, 242, 236, 236),
            elevation: 8,
            child: Observer(
              builder: (_) {
                if (createStore.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'Salvando anuncio',
                          style: TextStyle(fontSize: 18, color: Colors.purple),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.pink),
                        ),
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
                        //TITULO
                        label: 'Title',
                        initialValue: '',
                        onChanged: createStore.setTitle,
                        errorText: createStore.titleError,
                        maxLines: 2,
                      ),
                      _buildTextFormField(
                        label: 'Description',
                        initialValue: '',
                        onChanged: createStore.setDescription,
                        errorText: createStore.descriptionError,
                      ),
                      _buildTextFormField(
                        label: 'Price',
                        initialValue: '',
                        onChanged: createStore.setPrice,
                        errorText: createStore.priceError,
                      ),
                      HidephoneField(createStore: createStore),
                      Observer(builder: (_) {
                        return ErrorBox(message: createStore.error);
                      }),
                      Observer(builder: (_) {
                        return SizedBox(
                          height: 30,
                          child: GestureDetector(
                            onTap: createStore.invalidSendPressed,
                            child: ElevatedButton(
                              onPressed: createStore.sendPressed,
                              child: const Text('Send'),
                            ),
                          ),
                        );
                      })
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
