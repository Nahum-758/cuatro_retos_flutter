import 'package:flutter/material.dart';
import 'screens/reto1_peliculas.dart';
import 'screens/reto2_gatos.dart';
import 'screens/reto3_clima.dart';
import 'screens/reto4_cripto.dart';

void main() {
  runApp(const CuatroRetosApp());
}

class CuatroRetosApp extends StatelessWidget {
  const CuatroRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los 4 Retos Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final retos = [
      {
        'titulo': 'Reto 1: Recomendador de Películas',
        'subtitulo': 'UI + API Básica (OMDb / Estado de ánimo)',
        'icono': Icons.movie_filter,
        'color': Colors.deepPurple,
        'pantalla': const Reto1PeliculasScreen(),
      },
      {
        'titulo': 'Reto 2: Generador de Memes de Gatos',
        'subtitulo': 'API Cataas + URL Dinámica',
        'icono': Icons.pets,
        'color': Colors.orange,
        'pantalla': const Reto2GatosScreen(),
      },
      {
        'titulo': 'Reto 3: App del Clima Minimalista',
        'subtitulo': 'Open-Meteo + Geolocalización',
        'icono': Icons.cloud,
        'color': Colors.blue,
        'pantalla': const Reto3ClimaScreen(),
      },
      {
        'titulo': 'Reto 4: Convertidor de Criptomonedas',
        'subtitulo': 'API CoinGecko en Tiempo Real',
        'icono': Icons.currency_bitcoin,
        'color': Colors.green,
        'pantalla': const Reto4CriptoScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Los 4 Retos de Flutter'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: retos.length,
        itemBuilder: (context, index) {
          final reto = retos[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: (reto['color'] as Color).withOpacity(0.15),
                child: Icon(reto['icono'] as IconData, color: reto['color'] as Color),
              ),
              title: Text(
                reto['titulo'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(reto['subtitulo'] as String),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => reto['pantalla'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
