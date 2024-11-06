import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String text;
  const EmptyCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.7,
      child: Card(
        color: const Color.fromARGB(255, 239, 223, 242),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        margin: const EdgeInsets.all(32),
        child: Column(
          children: [
            //primeira parte tem dobro da segunda
            Expanded(
              flex: 2,
              child: Icon(
                Icons.clear_sharp,
                size: 150,
                color: const Color.fromARGB(255, 101, 86, 108),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Hmm...',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 101, 86, 108),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
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
