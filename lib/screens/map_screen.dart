import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mittelpunkt: z.B. Kiel Hbf
    final userPosition = LatLng(54.3213, 10.1349);

    final hotspots = [
      LatLng(54.3230, 10.1355), // Hotspot 1
      LatLng(54.3180, 10.1300), // Hotspot 2
      LatLng(54.3250, 10.1400), // Hotspot 3
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('KielSafe – Karte'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: userPosition,
          initialZoom: 13,
        ),
        children: [
          // 1) Kachel-Layer mit OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.kielsafe',
          ),

          // 2) Optional: Beispiel-Marker
          MarkerLayer(
            markers: [
              Marker(
                point: userPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                ),
              ),

              for (final point in hotspots)
                Marker(
                  point:point,
                  width:40,
                  height:40,
                  child:const Icon(
                    Icons.warning,
                    size:32),
                )

            ],
          ),
        ],
      ),
    );
  }
}