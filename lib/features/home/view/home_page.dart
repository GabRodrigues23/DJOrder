import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF180E6D),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF180E6D), Colors.blue.shade900],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  'DJOrder',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Gerenciador de Comandas',
                  style: TextStyle(color: Color(0xFFA9A9A9), fontSize: 16),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/manager');
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(150, 45)),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      color: Color(0xFF180E6D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TextButton.icon(
        onPressed: () {
          Modular.to.pushReplacementNamed('/settings');
        },
        icon: Icon(Icons.settings, color: Color(0xFFA9A9A9)),
        label: const Text(
          'Configurar Servidor',
          style: TextStyle(color: Color(0xFFA9A9A9)),
        ),
      ),
    );
  }
}
