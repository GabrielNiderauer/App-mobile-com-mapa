import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetofinal_o_retorno/pages/empresa_info.dart';
import 'dart:convert';
import 'package:projetofinal_o_retorno/pages/nova_empresa.dart';

class EmpresasPage extends StatefulWidget {
  const EmpresasPage({super.key});

  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  List empresas = [];

  @override
  void initState() {
    super.initState();
    _buscarEmpresas();
  }

  Future<void> _buscarEmpresas() async {
    final url = Uri.parse(
        'https://66df45b1de4426916ee41e3d.mockapi.io/api/projetoFinal/empresa');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        empresas = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar empresas')),
      );
    }
  }

  void _adicionarEmpresa(Map<String, String> novaEmpresa) {
    setState(() {
      empresas.add(novaEmpresa);
    });
  }

  Future<void> _excluirEmpresa(String id) async {
    final response = await http.delete(
      Uri.parse(
          'https://66df45b1de4426916ee41e3d.mockapi.io/api/projetoFinal/empresa/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        empresas.removeWhere((empresa) => empresa['id']?.toString() == id); 

      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empresa excluída com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir a empresa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
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
        child: empresas.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: empresas.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(empresas[index]['nome'] ?? 'Sem nome'),
                      subtitle: Text(
                          'Endereço: ${empresas[index]['endereco'] ?? 'Sem endereço'}, CNPJ: ${empresas[index]['cnpj'] ?? 'Sem CNPJ'}'),
                      leading:
                          const Icon(Icons.business, color: Colors.blueGrey),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InfoEmpresa(empresa: empresas[index])),
                        );
                      },
                      onLongPress: () async {
                        final bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmar Exclusão'),
                              content: const Text(
                                  'Tem certeza que deseja excluir esta empresa?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Excluir'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          await _excluirEmpresa(empresas[index]['id']!);
                        }
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaEmpresa = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CriarEmpresa(),
            ),
          );
          if (novaEmpresa != null) {
            _adicionarEmpresa(novaEmpresa);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
