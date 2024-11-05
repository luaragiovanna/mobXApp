// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageSourceDialog extends StatelessWidget {
  ImagePicker picker = ImagePicker();
  XFile? image;
  final Function(File) onImageSelected;
  ImageSourceDialog({
    Key? key,
    this.image,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return BottomSheet(
          //fechando modal
          onClosing: () {},
          builder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.5, shadowColor: Colors.pink.shade200),
                      onPressed: getFromCamera,
                      child: const Text(
                        'Camera',
                        style:
                            TextStyle(color: Color.fromARGB(255, 196, 71, 113)),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.5, shadowColor: Colors.pink.shade200),
                      onPressed: getFromGallery,
                      child: const Text(
                        'Galeria',
                        style:
                            TextStyle(color: Color.fromARGB(255, 196, 71, 113)),
                      )),
                ],
              ));
    } else {
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar',
                style: TextStyle(color: Color.fromARGB(255, 153, 8, 8)))),
        title: Text(
          'Realizar upload das imagens',
          style: TextStyle(fontSize: 18, color: Colors.pink.shade200),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: getFromCamera,
              child: Text(
                'Camera',
                style: TextStyle(color: Colors.grey.shade800),
              )),
          CupertinoActionSheetAction(
              onPressed: getFromGallery,
              child: Text('Galeria',
                  style: TextStyle(color: Colors.grey.shade800))),
        ],
      );
    }
  }

  Future<void> getFromCamera() async {
    image = (await picker.pickImage(source: ImageSource.camera));
    if (image == null) {
      return;
    }
    imageSelected(File(image!.path));
  }

  Future<void> getFromGallery() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    imageSelected(File(image!.path));
  }

  // Future<void> imageSelected(File imagePath) async {
  //   final image = await Image.file(imagePath);
  //   // final croppedFile = await ImageCropper().cropImage(
  //   //   sourcePath: imagePath.path,
  //   //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //   //   androidUiSettings: AndroidUiSettings(
  //   //       toolbarTitle: 'Editar imagem',
  //   //       toolbarColor: Colors.pink.shade100,
  //   //       toolbarWidgetColor: Colors.pink.shade700),
  //   //   iosUiSettings: const IOSUiSettings(
  //   //     title: 'Editar Imagem',
  //   //     cancelButtonTitle: 'Cancelar',
  //   //     doneButtonTitle: 'Concluir',
  //   //   ),
  //   // );
  //   //
  //   //onImageSelected();
  //   print('Tirando fotos ou pegando da galeria ${image}');
  // }

  Future<void> imageSelected(File imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final newImage = await imagePath.copy(newPath);

      print('Imagem salva em: ${newImage.path}');
      onImageSelected(newImage); // Chama a função passada como parâmetro
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
    }
  }
}
