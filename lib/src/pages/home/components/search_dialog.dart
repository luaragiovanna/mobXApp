import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final TextEditingController controller;
  final String currentSearch;

  SearchDialog({super.key, required this.currentSearch})
      : controller = TextEditingController(
            text:
                currentSearch); // Inicializa o controller com o valor de currentSearch

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          right: 2,
          left: 2,
          child: Card(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                prefixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Retorna null quando o usuário clica na seta (cancelar)
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.clear(); // Limpa o campo de pesquisa
                  },
                  icon: Icon(Icons.close),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                Navigator.of(context).pop(
                    text); // Retorna o valor quando o usuário submete a pesquisa
              },
              autofocus: true,
            ),
          ),
        )
      ],
    );
  }
}
