import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String message;

  const ErrorBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return Container();
    } else {
      return Container(
        color: Colors.red.withOpacity(0.5),
        child: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Text(
              'Oops! ${message} Por favor, tente novamente.',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ))
          ],
        ),
      );
    }
  }
}
