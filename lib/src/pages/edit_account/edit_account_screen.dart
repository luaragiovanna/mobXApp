import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_project/src/stores/page/page_store.dart';
import 'package:flutter_box_project/src/stores/user/edit_account_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditAccountScreen extends StatelessWidget {
  final EditAccountStore store = EditAccountStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Observer(builder: (_) {
                    return IgnorePointer(
                      ignoring: store.loading,
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          return ToggleSwitch(
                            minWidth: constraints.biggest.width / 2.01,
                            labels: const ['Particular', 'Profissional'],
                            cornerRadius: 20,

                            inactiveBgColor: Colors.grey,
                            activeFgColor: Colors.white,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: store.userType.index, //valores setados na store
                            // onToggle: store.setUserType,
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Observer(builder: (_) {
                    return TextFormField(
                      initialValue: store.name,
                      enabled: !store.loading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Nome*',
                        errorText: store.nameError,
                      ),
                      onChanged: store.setName,
                    );
                  }),
                  const SizedBox(height: 8),
                  Observer(builder: (_) {
                    return TextFormField(
                      initialValue: store.phone,
                      enabled: !store.loading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Telefone*',
                        errorText: store.phoneError,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      onChanged: store.setPhone,
                    );
                  }),
                  const SizedBox(height: 8),
                  Observer(builder: (_) {
                    return TextFormField(
                      enabled: !store.loading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Nova Senha',
                      ),
                      obscureText: true,
                      onChanged: store.setPass1,
                    );
                  }),
                  const SizedBox(height: 8),
                  Observer(builder: (_) {
                    return TextFormField(
                      enabled: !store.loading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Confirmar Nova Senha',
                        errorText: store.passError,
                      ),
                      obscureText: true,
                      onChanged: store.setPass2,
                    );
                  }),
                  const SizedBox(height: 12),
                  Observer(builder: (_) {
                    return SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.orange,
                          disabledIconColor: Colors.orange.withAlpha(100),
                          elevation: 0,
                        ),
                        // onPressed: store.savePressed,
                        onPressed: () {  },
                        child: store.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                'Salvar',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Sair',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        store.logout();
                        GetIt.I<PageStore>().setPage(0);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
