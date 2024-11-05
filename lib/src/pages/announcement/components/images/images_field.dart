import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_box_project/src/stores/create_announcment/create_store.dart';
import 'package:flutter_box_project/src/components/dialog/image_dialog.dart';
import 'package:flutter_box_project/src/pages/announcement/components/images/image_source_dialog.dart';

class ImagesField extends StatelessWidget {
  final CreateStore createStore;

  const ImagesField({
    Key? key,
    required this.createStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File image) {
      createStore.images.add(image);
      Navigator.of(context).pop();
    }

    return Column(
      children: [
        Container(
          color: Color.fromARGB(117, 247, 237, 241),
          height: 120,
          child: Observer(
            builder: (_) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: createStore.images.length < 4
                    ? createStore.images.length + 1
                    : 4,
                itemBuilder: (_, index) {
                  if (index == createStore.images.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return ImageSourceDialog(
                                onImageSelected: (File file) {
                                  onImageSelected(file);
                                },
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.pink.shade100,
                          child: const Icon(
                            Icons.camera_enhance,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => ImageDialog(
                              image: createStore.images[index],
                              onDelete: () {
                                createStore.images.removeAt(index);
                              },
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 44,
                          backgroundImage: FileImage(createStore.images[index]),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        Observer(
          builder: (_) {
            if (createStore.imagesError != null) {
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.red),
                  ),
                ),
                child: Text(
                  createStore.imagesError,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

          
            return Container(); 
          },
        ),
      ],
    );
  }
}
