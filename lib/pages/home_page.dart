import 'package:flutter/material.dart';
import 'package:provapratica/models/endereco_model.dart';
import 'package:provapratica/repositories/cep_repository.dart';
import 'package:provapratica/repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP Obrigatório';
                  } else if (value.length != 8 || !RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Digite um CEP válido com 8 dígitos';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Digite o CEP',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao buscar Endereço: $e')),
                      );
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 20),
              if (enderecoModel != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Logradouro: ${enderecoModel!.logradouro}'),
                    Text('Complemento: ${enderecoModel!.complemento}'),
                    Text('CEP: ${enderecoModel!.cep}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
