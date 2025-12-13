import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _urlController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _urlController.text = prefs.getString('api_base_url') ?? 'http://';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    String url = _urlController.text.trim();
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    await prefs.setString('api_base_url', url);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Configurações salvas com sucesso!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração do Servidor'),
        actions: [
          IconButton(
            onPressed: () {
              Modular.to.pushReplacementNamed('/');
            },
            icon: Icon(Icons.keyboard_return, color: Color(0xFF180E6D)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.settings_ethernet,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Conexão com DJORDER SERVER',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'URL Base do Servidor',
                        hintText: 'http://127.0.0.1:9000',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Informe a URL';
                        if (!value.startsWith('http://'))
                          return 'A URL deve começar com http://';
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save),
                      label: const Text('SALVAR CONFIGURAÇÃO'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
