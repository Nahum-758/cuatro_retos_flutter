import 'package:flutter/material.dart';

class Reto2GatosScreen extends StatefulWidget {
  const Reto2GatosScreen({super.key});

  @override
  State<Reto2GatosScreen> createState() => _Reto2GatosScreenState();
}

class _Reto2GatosScreenState extends State<Reto2GatosScreen> {
  final TextEditingController _textoController = TextEditingController();
  String _frase = '';
  String _filtro = '';
  int _seed = DateTime.now().millisecondsSinceEpoch;

  final Map<String, String> _filtrosDisponibles = {
    'Normal': '',
    'Blanco y Negro': 'mono',
    'Sepia': 'sepia',
    'Negativo': 'negate',
    'Pixelado': 'pixel',
  };

  String _construirUrlGato() {
    final textoCodificado = Uri.encodeComponent(_frase.trim());
    String base = _frase.trim().isEmpty
        ? 'https://cataas.com/cat'
        : 'https://cataas.com/cat/says/$textoCodificado';

    final params = <String>['t=$_seed', 'fontSize=40', 'fontColor=white'];
    if (_filtro.isNotEmpty) {
      params.add('filter=$_filtro');
    }
    return '$base?${params.join('&')}';
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = _construirUrlGato();

    return Scaffold(
      appBar: AppBar(title: const Text('Generador de Memes de Gatos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                height: 320,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 8),
                        Text('No se pudo cargar el gato. Intenta de nuevo.'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textoController,
              decoration: InputDecoration(
                labelText: 'Texto del meme',
                hintText: 'Ej. Cuando compila a la primera...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textoController.clear();
                    setState(() => _frase = '');
                  },
                ),
              ),
              onSubmitted: (val) => setState(() => _frase = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _filtro,
              decoration: const InputDecoration(
                labelText: 'Filtro de imagen',
                border: OutlineInputBorder(),
              ),
              items: _filtrosDisponibles.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _filtro = val);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _frase = _textoController.text;
                      });
                    },
                    icon: const Icon(Icons.text_fields),
                    label: const Text('Aplicar Texto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _frase = _textoController.text;
                        _seed = DateTime.now().millisecondsSinceEpoch;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Otro Gato'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
