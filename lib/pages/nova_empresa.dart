import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetofinal_o_retorno/models/empresa.dart';
import 'package:projetofinal_o_retorno/pages/home_page.dart';

class CriarEmpresa extends StatefulWidget {
  const CriarEmpresa({super.key});

  @override
  State<CriarEmpresa> createState() => _CriarEmpresaState();
}

class _CriarEmpresaState extends State<CriarEmpresa> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  Future<void> _salvarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text.toUpperCase();
      String endereco = _enderecoController.text.toUpperCase();
      String cnpj = _cnpjController.text.toUpperCase();

      Empresa empresa = Empresa(
        nome: nome,
        endereco: endereco,
        cnpj: cnpj,
      );

      const String url = 'https://66df45b1de4426916ee41e3d.mockapi.io/api/projetoFinal/empresa';
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(empresa.toJson()),
        );

        if (response.statusCode == 201) {
          // Navegar para a HomePage após salvar com sucesso
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          throw Exception('Erro ao salvar empresa: ${response.statusCode}');
        }
      } catch (e) {
        print('Erro ao salvar empresa: $e');
        _showErrorDialog('Erro ao salvar empresa. Tente novamente.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Empresa'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4, 0.6, 0.9],
            colors: [
              Colors.grey,
              Color.fromARGB(255, 115, 115, 115),
              Color.fromARGB(255, 65, 65, 65),
              Color.fromARGB(255, 30, 30, 30),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _inputField("Nome da Empresa", _nomeController),
                    const SizedBox(height: 16),
                    _inputField("Endereço", _enderecoController),
                    const SizedBox(height: 16),
                    _inputField("CNPJ", _cnpjController, isCNPJ: true),
                    const SizedBox(height: 24),
                    _salvarBtn(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false, bool isCNPJ = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      keyboardType: isCNPJ ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira o $hintText';
        }
        if (isCNPJ && value.length != 14) {
          return 'O CNPJ deve ter 14 dígitos';
        }
        return null;
      },
    );
  }

  Widget _salvarBtn() {
    return ElevatedButton(
      onPressed: _salvarEmpresa,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: const Color.fromARGB(255, 228, 228, 226),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Salvar Empresa",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
