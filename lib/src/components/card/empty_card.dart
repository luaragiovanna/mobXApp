import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String text;
  const EmptyCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        margin: const EdgeInsets.all(32),
        child: Column(
          children: [
            //primeira parte tem dobro da segunda
            const Expanded(
              flex: 2,
              child: Icon(
                Icons.clear_sharp,
                size: 150,
                color: Colors.grey,
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Hhmm...',
                    style: TextStyle(color: Colors.purple),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
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
