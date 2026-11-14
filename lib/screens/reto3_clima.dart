import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';

class Reto3ClimaScreen extends StatefulWidget {
  const Reto3ClimaScreen({super.key});

  @override
  State<Reto3ClimaScreen> createState() => _Reto3ClimaScreenState();
}

class _Reto3ClimaScreenState extends State<Reto3ClimaScreen> {
  final TextEditingController _ciudadController = TextEditingController(text: 'Celaya');
  late Future<Map<String, dynamic>> _climaFuture;

  @override
  void initState() {
    super.initState();
    _climaFuture = ApiService.buscarCiudadYClima('Celaya');
  }

  void _buscarPorCiudad() {
    if (_ciudadController.text.trim().isEmpty) return;
    setState(() {
      _climaFuture = ApiService.buscarCiudadYClima(_ciudadController.text.trim());
    });
  }

  Future<void> _usarUbicacionActual() async {
    setState(() {
      _climaFuture = _obtenerClimaGPS();
    });
  }

  Future<Map<String, dynamic>> _obtenerClimaGPS() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('Los servicios de ubicación están desactivados.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception('Permiso de ubicación denegado permanentemente.');
    }

    final pos = await Geolocator.getCurrentPosition();
    final datos = await ApiService.obtenerClimaPorCoordenadas(pos.latitude, pos.longitude);
    datos['city_name'] = 'Mi Ubicación Actual (${pos.latitude.toStringAsFixed(2)}, ${pos.longitude.toStringAsFixed(2)})';
    return datos;
  }

  String _descripcionClima(int code) {
    if (code == 0) return 'Despejado ☀️';
    if (code <= 3) return 'Parcialmente nublado ⛅';
    if (code <= 48) return 'Niebla 🌫️';
    if (code <= 67) return 'Lluvia 🌧️';
    if (code <= 77) return 'Nieve ❄️';
    if (code <= 99) return 'Tormenta eléctrica ⛈️';
    return 'Clima variable';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima Minimalista')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ciudadController,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _buscarPorCiudad(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _buscarPorCiudad,
                  icon: const Icon(Icons.search),
                  tooltip: 'Buscar ciudad',
                ),
                const SizedBox(width: 4),
                IconButton.outlined(
                  onPressed: _usarUbicacionActual,
                  icon: const Icon(Icons.my_location),
                  tooltip: 'Usar mi GPS',
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _climaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final current = data['current'];
                  final temp = current['temperature_2m'];
                  final humedad = current['relative_humidity_2m'];
                  final viento = current['wind_speed_10m'];
                  final code = current['weather_code'] as int;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['city_name'] ?? 'Ciudad',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$temp °C',
                        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _descripcionClima(code),
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _InfoExtra(icono: Icons.water_drop, etiqueta: 'Humedad', valor: '$humedad%'),
                          _InfoExtra(icono: Icons.air, etiqueta: 'Viento', valor: '$viento km/h'),
                        ],
                      ),
                    ],
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

class _InfoExtra extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _InfoExtra({required this.icono, required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: Colors.blue),
        const SizedBox(height: 4),
        Text(etiqueta, style: const TextStyle(color: Colors.grey)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
