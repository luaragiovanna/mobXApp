import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final dynamic image;
  const ImageDialog({super.key, required this.onDelete, this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(image),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red),))
        ],
      ),
    );
  }
}
