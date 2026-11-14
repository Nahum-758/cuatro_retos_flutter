import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  // OMDb API Key pública de demostración (puedes reemplazarla por la tuya gratis en omdbapi.com)
  static const String _omdbApiKey = 'trilogy';

  static final Map<String, List<String>> _peliculasPorAnimo = {
    'Acción / Adrenalina': ['tt0468569', 'tt1375666', 'tt4154796', 'tt0133093', 'tt2911666'],
    'Comedia / Relajado': ['tt0107048', 'tt0829482', 'tt1119646', 'tt0365748', 'tt2278388'],
    'Ciencia Ficción / Pensar': ['tt0816692', 'tt1856101', 'tt2543164', 'tt0110912', 'tt0083658'],
    'Terror / Suspenso': ['tt1457767', 'tt5052448', 'tt0081505', 'tt7784604', 'tt1396484'],
  };

  static Future<Map<String, dynamic>> obtenerPeliculaPorAnimo(String animo) async {
    final lista = _peliculasPorAnimo[animo] ?? _peliculasPorAnimo.values.first;
    final imdbId = lista[Random().nextInt(lista.length)];
    final url = Uri.parse('https://www.omdbapi.com/?i=$imdbId&apikey=$_omdbApiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        return data;
      }
      throw Exception(data['Error'] ?? 'No se encontró la película');
    } else {
      throw Exception('Error de conexión con OMDb (${response.statusCode})');
    }
  }

  // Open-Meteo (100% gratuita y sin API Key requerida)
  static Future<Map<String, dynamic>> obtenerClimaPorCoordenadas(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&timezone=auto',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener clima (${response.statusCode})');
    }
  }

  static Future<Map<String, dynamic>> buscarCiudadYClima(String ciudad) async {
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(ciudad)}&count=1&language=es&format=json',
    );
    final geoResp = await http.get(geoUrl);
    if (geoResp.statusCode != 200) {
      throw Exception('Error buscando la ciudad');
    }
    final geoData = jsonDecode(geoResp.body);
    if (geoData['results'] == null || (geoData['results'] as List).isEmpty) {
      throw Exception('Ciudad no encontrada');
    }

    final lugar = geoData['results'][0];
    final clima = await obtenerClimaPorCoordenadas(lugar['latitude'], lugar['longitude']);
    clima['city_name'] = '${lugar['name']}, ${lugar['country'] ?? ''}';
    return clima;
  }

  // CoinGecko API pública sin autenticación
  static Future<Map<String, dynamic>> obtenerPreciosCripto() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al consultar CoinGecko (${response.statusCode})');
    }
  }
}
