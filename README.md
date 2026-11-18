# Los 4 Retos de Flutter (Proyecto Completo)

Este proyecto integra los 4 retos en una sola aplicación con menú de navegación y servicios HTTP funcionales sin necesidad de configuraciones complejas.

## Cómo ejecutarlo

1. Extrae este archivo ZIP.
2. Abre una terminal dentro de la carpeta `cuatro_retos_flutter`.
3. Si necesitas generar las carpetas nativas (`android/`, `windows/`, `web/`), ejecuta:
   flutter create .

4. Instala las dependencias:
   flutter pub get

5. Ejecuta la aplicación:
   flutter run


## Qué incluye cada pantalla
- **Reto 1 (`lib/screens/reto1_peliculas.dart`)**: Selector por estado de ánimo conectado a la API de OMDb con tarjeta, póster, calificación IMDb y sinopsis.
- **Reto 2 (`lib/screens/reto2_gatos.dart`)**: Generador de memes en tiempo real con Cataas, texto personalizado y filtros visuales (blanco y negro, sepia, negativo, pixelado).
- **Reto 3 (`lib/screens/reto3_clima.dart`)**: Consulta de clima por nombre de ciudad o mediante GPS (`geolocator`) usando Open-Meteo (no requiere API key).
- **Reto 4 (`lib/screens/reto4_cripto.dart`)**: Cotización en tiempo real de Bitcoin, Ethereum y Solana desde CoinGecko con cálculo instantáneo de fracciones según el monto en USD.
