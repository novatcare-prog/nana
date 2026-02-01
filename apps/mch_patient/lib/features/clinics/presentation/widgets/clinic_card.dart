import 'package:flutter/material.dart';
import '../../domain/models/clinic.dart';

class ClinicCard extends StatelessWidget {
  final Clinic clinic;
  final VoidCallback? onTap;
  final VoidCallback? onDirectionsTap;

  const ClinicCard({
    super.key,
    required this.clinic,
    this.onTap,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Icon/Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_hospital,
                    color: Color(0xFFE91E63), size: 30),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clinic.address,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Rating and Status
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          clinic.rating.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: clinic.isOpen
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            clinic.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: clinic.isOpen
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Services
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: clinic.services
                          .take(3)
                          .map((service) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Text(
                                  service,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[700]),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // Directions Button
              IconButton(
                onPressed: onDirectionsTap ?? () {},
                icon: const CircleAvatar(
                  backgroundColor: Color(0xFFE91E63),
                  radius: 18,
                  child: Icon(Icons.directions, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
