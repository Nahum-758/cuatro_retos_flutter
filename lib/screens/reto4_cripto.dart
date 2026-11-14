import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Reto4CriptoScreen extends StatefulWidget {
  const Reto4CriptoScreen({super.key});

  @override
  State<Reto4CriptoScreen> createState() => _Reto4CriptoScreenState();
}

class _Reto4CriptoScreenState extends State<Reto4CriptoScreen> {
  final TextEditingController _usdController = TextEditingController(text: '100');
  double _montoUsd = 100.0;
  late Future<Map<String, dynamic>> _preciosFuture;

  @override
  void initState() {
    super.initState();
    _preciosFuture = ApiService.obtenerPreciosCripto();
  }

  void _refrescarPrecios() {
    setState(() {
      _preciosFuture = ApiService.obtenerPreciosCripto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertidor Cripto'),
        actions: [
          IconButton(
            onPressed: _refrescarPrecios,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar precios',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usdController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto a invertir en USD (\$)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  _montoUsd = double.tryParse(valor) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _preciosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _refrescarPrecios,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final criptos = [
                    {
                      'nombre': 'Bitcoin',
                      'simbolo': 'BTC',
                      'precio': (data['bitcoin']['usd'] as num).toDouble(),
                      'color': Colors.orange,
                    },
                    {
                      'nombre': 'Ethereum',
                      'simbolo': 'ETH',
                      'precio': (data['ethereum']['usd'] as num).toDouble(),
                      'color': Colors.indigo,
                    },
                    {
                      'nombre': 'Solana',
                      'simbolo': 'SOL',
                      'precio': (data['solana']['usd'] as num).toDouble(),
                      'color': Colors.teal,
                    },
                  ];

                  return ListView.builder(
                    itemCount: criptos.length,
                    itemBuilder: (context, index) {
                      final c = criptos[index];
                      final precio = c['precio'] as double;
                      final cantidadComprable = precio > 0 ? _montoUsd / precio : 0.0;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: (c['color'] as Color).withOpacity(0.15),
                            child: Text(
                              c['simbolo'] as String,
                              style: TextStyle(
                                color: c['color'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            c['nombre'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Precio actual: \$${precio.toStringAsFixed(2)} USD'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${cantidadComprable.toStringAsFixed(6)} ${c['simbolo']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.green,
                                ),
                              ),
                              const Text('Recibirías', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
