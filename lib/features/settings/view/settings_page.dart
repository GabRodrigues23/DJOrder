import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:djorder/features/settings/service/settings_service.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _service = SettingsService();

  late TextEditingController _urlController;
  late TextEditingController _warningController;
  late TextEditingController _criticalController;

  late int _refreshInterval;
  late bool _soundEnabled;
  late bool _slaEnabled;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _service.apiUrl);
    _warningController = TextEditingController(
      text: _service.warningMinutes.toString(),
    );
    _criticalController = TextEditingController(
      text: _service.criticalMinutes.toString(),
    );
    _refreshInterval = _service.refreshInterval;
    _soundEnabled = _service.isSoundEnabled;
    _slaEnabled = _service.isSlaEnables;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _warningController.dispose();
    _criticalController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    await _service.setApiUrl(_urlController.text);
    await _service.setRefreshInterval(_refreshInterval);
    await _service.setSlaEnabled(_slaEnabled);
    await _service.setWarningMinutes(
      int.tryParse(_warningController.text) ?? 30,
    );
    await _service.setCriticalMinutes(
      int.tryParse(_criticalController.text) ?? 60,
    );
    await _service.setSoundEnabled(_soundEnabled);

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
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF180E6D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSectionTitle('Conexão'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'URL da API (Servidor Lazarus)',
                          hintText: 'Ex: http://192.168.0.100:9000',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: _refreshInterval,
                        decoration: const InputDecoration(
                          labelText: 'Intervalo de Atualização Automática',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.timer),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 5,
                            child: Text('5 Segundos (Rápido)'),
                          ),
                          DropdownMenuItem(
                            value: 10,
                            child: Text('10 Segundos (Médio)'),
                          ),
                          DropdownMenuItem(
                            value: 30,
                            child: Text('30 Segundos (Lento)'),
                          ),
                          DropdownMenuItem(
                            value: 60,
                            child: Text('1 Minuto (Econômico)'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _refreshInterval = value!),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Alertas de Tempo (SLA)'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Habilitar cores de Alerta'),
                      subtitle: const Text(
                        'Mudar a cor da comanda baseado no tempo de espera.',
                      ),
                      value: _slaEnabled,
                      activeThumbColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          _slaEnabled = value;
                        });
                      },
                    ),

                    if (_slaEnabled) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildNumberInput(
                                controller: _warningController,
                                label: 'Alerta Amarelo (min)',
                                icon: Icons.warning_amber,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildNumberInput(
                                controller: _criticalController,
                                label: 'Alerta Vermelho (min)',
                                icon: Icons.error_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Notificações'),
              Card(
                child: SwitchListTile(
                  title: const Text('Som de Novo Pedido'),
                  subtitle: const Text(
                    'Tocar um alerta sonoro quando chegar uma nova comanda.',
                  ),
                  secondary: Icon(
                    _soundEnabled ? Icons.volume_up : Icons.volume_off,
                    color: _soundEnabled ? Colors.blue : Colors.grey,
                  ),
                  value: _soundEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: const Text('SALVAR CONFIGURAÇÕES'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF180E6D),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: enabled ? color : Colors.grey),
        filled: !enabled,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
