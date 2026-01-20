import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetofinal_o_retorno/pages/home_page.dart'; // Importe a HomePage

class EditaEmpresa extends StatefulWidget {
  final Map<String, dynamic> empresa;

  const EditaEmpresa({super.key, required this.empresa});

  @override
  State<EditaEmpresa> createState() => _EditaEmpresaState();
}

class _EditaEmpresaState extends State<EditaEmpresa> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _enderecoController;
  late TextEditingController _cnpjController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.empresa['nome']);
    _enderecoController = TextEditingController(text: widget.empresa['endereco']);
    _cnpjController = TextEditingController(text: widget.empresa['cnpj']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  Future<void> _salvarEmpresa() async {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text;
      String endereco = _enderecoController.text;
      String cnpj = _cnpjController.text;

      final id = widget.empresa['id'];

      if (id != null) {
        final url = Uri.parse(
            'https://66df45b1de4426916ee41e3d.mockapi.io/api/projetoFinal/empresa/$id');

        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nome': nome,
            'endereco': endereco,
            'cnpj': cnpj,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao atualizar a empresa')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID da empresa não encontrado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empresa'),
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

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false, bool isCNPJ = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

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
              "Salvar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )));
  }
}
