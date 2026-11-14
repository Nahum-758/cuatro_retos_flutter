import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Reto1PeliculasScreen extends StatefulWidget {
  const Reto1PeliculasScreen({super.key});

  @override
  State<Reto1PeliculasScreen> createState() => _Reto1PeliculasScreenState();
}

class _Reto1PeliculasScreenState extends State<Reto1PeliculasScreen> {
  final List<String> _estadosAnimo = [
    'Acción / Adrenalina',
    'Comedia / Relajado',
    'Ciencia Ficción / Pensar',
    'Terror / Suspenso',
  ];

  String _animoSeleccionado = 'Acción / Adrenalina';
  late Future<Map<String, dynamic>> _peliculaFuture;

  @override
  void initState() {
    super.initState();
    _cargarNuevaPelicula();
  }

  void _cargarNuevaPelicula() {
    setState(() {
      _peliculaFuture = ApiService.obtenerPeliculaPorAnimo(_animoSeleccionado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recomendador de Películas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Qué tienes ganas de ver este fin de semana?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _animoSeleccionado,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _estadosAnimo
                  .map((animo) => DropdownMenuItem(value: animo, child: Text(animo)))
                  .toList(),
              onChanged: (valor) {
                if (valor != null) {
                  _animoSeleccionado = valor;
                  _cargarNuevaPelicula();
                }
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _cargarNuevaPelicula,
              icon: const Icon(Icons.shuffle),
              label: const Text('Recomendar otra película'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _peliculaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final movie = snapshot.data!;
                final poster = movie['Poster'] != null && movie['Poster'] != 'N/A'
                    ? movie['Poster']
                    : null;

                return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (poster != null)
                        Image.network(
                          poster,
                          height: 360,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 200,
                            child: Center(child: Icon(Icons.broken_image, size: 60)),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${movie['Title']} (${movie['Year']})',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                                  label: Text(movie['imdbRating'] ?? 'N/A'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${movie['Genre']} • ${movie['Runtime']}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              movie['Plot'] ?? 'Sin sinopsis disponible.',
                              style: const TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
