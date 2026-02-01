class HealthWorker {
  final String id;
  final String name;
  final String role; // e.g., "Nurse", "Midwife", "Pediatrician"
  final String facilityId;
  final String? imageUrl;
  final double rating;
  final bool isAvailable;

  const HealthWorker({
    required this.id,
    required this.name,
    required this.role,
    required this.facilityId,
    this.imageUrl,
    this.rating = 4.5,
    this.isAvailable = true,
  });
}
