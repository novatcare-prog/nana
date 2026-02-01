import 'package:latlong2/latlong.dart';

class Clinic {
  final String id;
  final String name;
  final LatLng location;
  final String address;
  final String phone;
  final List<String> services;
  final bool isOpen;
  final double rating;

  const Clinic({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.phone,
    required this.services,
    this.isOpen = true,
    this.rating = 4.5,
  });
}
