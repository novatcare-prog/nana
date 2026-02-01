import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/models/clinic.dart';

class ClinicMapView extends StatelessWidget {
  final List<Clinic> clinics;

  const ClinicMapView({super.key, required this.clinics});

  @override
  Widget build(BuildContext context) {
    // Center map on Nairobi for now, or the first clinic
    final initialCenter = clinics.isNotEmpty
        ? clinics.first.location
        : const LatLng(-1.2921, 36.8219);

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 12.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mch_patient.app',
        ),
        MarkerLayer(
          markers: clinics
              .map((clinic) => Marker(
                    point: clinic.location,
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        _showClinicPreview(context, clinic);
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFFE91E63),
                        size: 40,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _showClinicPreview(BuildContext context, Clinic clinic) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clinic.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(clinic.address),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Trigger directions logic if implemented
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Directions opening...')),
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
