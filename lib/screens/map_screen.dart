import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotspot.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mittelpunkt: z.B. Kiel Hbf
    final userPosition = LatLng(54.3213, 10.1349);

    final hotspots = <Hotspot>[
      Hotspot(
        id: 1,
        title: 'Gefährliche Kreuzung',
        description: 'Unübersichtliche Kreuzung mit vielen abbiegenden Autos.',
        position: LatLng(54.3230, 10.1355),
      ),
      Hotspot(
        id: 2,
        title: 'Enger Radweg',
        description: 'Sehr schmaler Radweg, häufiges Dooring-Risiko.',
        position: LatLng(54.3180, 10.1300),
      ),
      Hotspot(
        id: 3,
        title: 'Schlaglöcher',
        description: 'Viele Schlaglöcher – bei Nässe schlecht zu sehen.',
        position: LatLng(54.3250, 10.1400),
      ),
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
              // Nutzer-Marker
              Marker(
                point: userPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.person_pin_circle,
                  size: 40,
                ),
              ),

              // Hotspot-Marker
              for (final hotspot in hotspots)
                Marker(
                  point: hotspot.position,
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius
                              .circular(16)),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Wrap(
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Text(
                                  hotspot.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hotspot.description,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.place, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Lat: ${hotspot.position.latitude
                                          .toStringAsFixed(5)}, '
                                          'Lng: ${hotspot.position.longitude
                                          .toStringAsFixed(5)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Schließen'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.warning,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}