import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotspot.dart';

// Dummy data for now – later you can load this from a service/backend.
final List<Hotspot> _hotspots = <Hotspot>[
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

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Fallback Mitte: Kiel Hbf
  static const LatLng _fallbackCenter = LatLng(54.3213, 10.1349);

  LatLng? _userPosition;
  bool _isRequestingLocation = false;
  String? _locationError;

  // Radius um einen Hotspot (in Metern), ab dem gewarnt wird


  // Distanz-Berechnung (aus latlong2)
  final Distance _distance = const Distance();

  // Merken, für welche Hotspots bereits gewarnt wurde, damit keine Dauer-Spam-Nachrichten kommen


  static const double _dangerRadiusMeters = 1000.0;



  final Set<int> _notifiedHotspots = <int>{};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    setState(() {
      _isRequestingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Standortdienste sind deaktiviert.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Kein Zugriff auf den Standort (Berechtigung verweigert).';
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userPosition = LatLng(pos.latitude, pos.longitude);
      });
      if (_userPosition != null) {
        _checkProximityToHotspots(_userPosition!);
      }
    } catch (e) {
      setState(() {
        _locationError = 'Fehler beim Laden des Standorts: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingLocation = false;
        });
      }
    }
  }

  void _checkProximityToHotspots(LatLng position) {
    // Wenn kein Scaffold vorhanden ist (z.B. während Build), keine Nachricht anzeigen
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    for (final hotspot in _hotspots) {
      final distanceInMeters = _distance.as(
        LengthUnit.Meter,
        position,
        hotspot.position,
      );

      if (distanceInMeters <= _dangerRadiusMeters) {
        // Nur warnen, wenn dieser Hotspot noch nicht gemeldet wurde
        if (_notifiedHotspots.add(hotspot.id)) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Achtung! Du bist in der Nähe von "${hotspot.title}".',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Wenn man wieder weit genug weg ist, kann dieser Hotspot in Zukunft erneut melden
        _notifiedHotspots.remove(hotspot.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = _userPosition ?? _fallbackCenter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KielSafe – Karte'),
        actions: [
          IconButton(
            tooltip: 'Standort aktualisieren',
            onPressed: _isRequestingLocation ? null : _initLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
              // Tipp auf die Karte verschiebt den User-Pin
              onTap: (tapPosition, latLng) {
                setState(() {
                  _userPosition = latLng;
                });
                _checkProximityToHotspots(latLng);
              },
            ),
            children: [
              _buildTileLayer(),
              _buildMarkerLayer(context, userPosition: _userPosition),
            ],
          ),
          if (_isRequestingLocation)
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Standort wird ermittelt ...'),
                    ],
                  ),
                ),
              ),
            ),
          if (_locationError != null && !_isRequestingLocation)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$_locationError',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

TileLayer _buildTileLayer() {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.kielsafe',
  );
}

MarkerLayer _buildMarkerLayer(BuildContext context, {required LatLng? userPosition}) {
  return MarkerLayer(
    markers: [
      if (userPosition != null)
        Marker(
          point: userPosition,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.person_pin_circle,
            size: 40,
          ),
        ),
      for (final hotspot in _hotspots)
        Marker(
          point: hotspot.position,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showHotspotBottomSheet(context, hotspot),
            child: const Icon(
              Icons.warning,
              size: 32,
            ),
          ),
        ),
    ],
  );
}


void _showHotspotBottomSheet(BuildContext context, Hotspot hotspot) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) => _HotspotBottomSheet(hotspot: hotspot),
  );
}

class _HotspotBottomSheet extends StatelessWidget {
  final Hotspot hotspot;

  const _HotspotBottomSheet({required this.hotspot});

  @override
  Widget build(BuildContext context) {
    final position = hotspot.position;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(hotspot.description),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.place, size: 18),
              const SizedBox(width: 8),
              Text(
                'Lat: ${position.latitude.toStringAsFixed(5)}, '
                'Lng: ${position.longitude.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Schließen'),
            ),
          ),
        ],
      ),
    );
  }
}