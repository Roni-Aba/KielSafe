import 'package:latlong2/latlong.dart';

class Hotspot {
  final int id;
  final String title;
  final String description;
  final LatLng position;

  Hotspot({
    required this.id,
    required this.title,
    required this.description,
    required this.position
});
}