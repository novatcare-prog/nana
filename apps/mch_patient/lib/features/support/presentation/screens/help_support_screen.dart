import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'How do I book an appointment?',
              'Go to the Appointments tab and click the "+" button (coming soon), or visit your nearest facility.',
            ),
            _buildFaqItem(
              'How do I add my child?',
              'Go to the Children tab and click the "+" button. Fill in the required details to register your child.',
            ),
            _buildFaqItem(
              'Can I share my records?',
              'Yes, go to your Profile and select "Share Medical Records" to generate a QR code for your health worker.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.orange),
              title: const Text('Email Support'),
              subtitle: const Text('support@mch-app.com'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Call Helpline'),
              subtitle: const Text('0800 123 456'),
              onTap: () {},
            ),
          ],
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
}
