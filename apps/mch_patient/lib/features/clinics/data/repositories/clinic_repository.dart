import 'package:latlong2/latlong.dart';
import '../../domain/models/clinic.dart';
import '../../domain/models/health_worker.dart';

class ClinicRepository {
  Future<List<Clinic>> getNearbyClinics() async {
    // Mock data for Nairobi area with realistic coordinates
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      const Clinic(
        id: '1',
        name: 'Mama Lucy Kibaki Hospital',
        location: LatLng(-1.2833, 36.8958),
        address: 'Kayole, Nairobi',
        phone: '+254 700 000 000',
        services: ['Maternity', 'Pediatrics', 'ANC'],
        isOpen: true,
        rating: 4.2,
      ),
      const Clinic(
        id: '2',
        name: 'Pumwani Maternity Hospital',
        location: LatLng(-1.2789, 36.8406),
        address: 'Pumwani, Nairobi',
        phone: '+254 711 111 111',
        services: ['Maternity', 'ANC', 'Delivery'],
        isOpen: true,
        rating: 4.0,
      ),
      const Clinic(
        id: '3',
        name: 'Kenyatta National Hospital',
        location: LatLng(-1.3028, 36.8070),
        address: 'Hospital Rd, Nairobi',
        phone: '+254 722 222 222',
        services: ['General', 'Specialized', 'Pediatrics', 'PNC'],
        isOpen: true,
        rating: 4.5,
      ),
      const Clinic(
        id: '4',
        name: 'Aga Khan University Hospital',
        location: LatLng(-1.2618, 36.8227),
        address: '3rd Parklands Ave, Nairobi',
        phone: '+254 733 333 333',
        services: ['Premium Care', 'Emergency', 'Ultrasound'],
        isOpen: true,
        rating: 4.8,
      ),
      const Clinic(
        id: '5',
        name: 'Mbagathi County Hospital',
        location: LatLng(-1.3069, 36.8016),
        address: 'Mbagathi Way, Nairobi',
        phone: '+254 744 444 444',
        services: ['Maternity', 'Child Welfare'],
        isOpen: true,
        rating: 3.9,
      ),
    ];
  }

  Future<List<HealthWorker>> getHealthWorkersByClinicId(String clinicId) async {
    // Mock data
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      HealthWorker(
        id: 'hw1',
        name: 'Sarah Kimani',
        role: 'Nurse Midwife',
        facilityId: clinicId,
        rating: 4.8,
        isAvailable: true,
      ),
      HealthWorker(
        id: 'hw2',
        name: 'Dr. James Omondi',
        role: 'Pediatrician',
        facilityId: clinicId,
        rating: 4.9,
        isAvailable: true,
      ),
      HealthWorker(
        id: 'hw3',
        name: 'Beatrice Wanjiku',
        role: 'Clinical Officer',
        facilityId: clinicId,
        rating: 4.5,
        isAvailable: true,
      ),
      HealthWorker(
        id: 'hw4',
        name: 'Grace Mwangi',
        role: 'Nutritionist',
        facilityId: clinicId,
        rating: 4.7,
        isAvailable: false,
      ),
    ];
  }
}
