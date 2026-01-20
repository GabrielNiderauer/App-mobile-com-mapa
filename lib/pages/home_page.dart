import 'package:flutter/material.dart';
import 'package:projetofinal_o_retorno/pages/empresas.dart';
import 'package:projetofinal_o_retorno/pages/login_page.dart';
import 'package:projetofinal_o_retorno/pages/mapa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Sair"),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()))
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Empresas"),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmpresasPage()))
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Mapa"),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapaPage()))
              },
            ),
          ],
        ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/logoUpf.png',
                height: 150,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    _buildCard('Algo pro Futuro', Icons.star),
                    _buildCard('Empresas', Icons.business, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmpresasPage()),
                      );
                    }),
                    _buildCard('Mapa', Icons.map, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapaPage()),
                      );
                    }),
                    _buildCard('Configurações', Icons.settings),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white.withOpacity(0.8),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
