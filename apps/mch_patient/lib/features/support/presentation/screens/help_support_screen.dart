import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help.title'.tr()),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'help.faq'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'help.faq_booking'.tr(),
              'help.faq_booking_answer'.tr(),
            ),
            _buildFaqItem(
              'help.faq_children'.tr(),
              'help.faq_children_answer'.tr(),
            ),
            _buildFaqItem(
              'help.faq_share'.tr(),
              'help.faq_share_answer'.tr(),
            ),
            const SizedBox(height: 32),
            Text(
              'help.contact_support'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.orange),
              title: Text('help.email_support'.tr()),
              subtitle: const Text('support@mch-app.com'),
              onTap: () => _sendEmail('support@mch-app.com'),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text('help.call_helpline'.tr()),
              subtitle: const Text('0800 123 456'),
              onTap: () => _makePhoneCall('0800123456'),
            ),
            const SizedBox(height: 32),
            // Emergency Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emergency, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'help.emergency_numbers'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEmergencyTile('help.ambulance'.tr(), '999', Colors.red),
                  _buildEmergencyTile('help.health_helpline'.tr(),
                      '0800 720 720', Colors.green),
                  _buildEmergencyTile(
                      'help.general_emergency'.tr(), '112', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTile(String label, String number, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _makePhoneCall(number.replaceAll(' ', '')),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Icon(Icons.phone, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
