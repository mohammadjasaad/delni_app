import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  final List<Map<String, dynamic>> services = const [
    {'icon': Icons.local_taxi, 'label': 'Delni Taxi'},
    {'icon': Icons.assignment, 'label': 'نقل ملكية'},
    {'icon': Icons.security, 'label': 'تأمين سيارات'},
    {'icon': Icons.build_circle, 'label': 'صيانة'},
    {'icon': Icons.gavel, 'label': 'مزايدات'},
    {'icon': Icons.home_work, 'label': 'تقييم عقار'},
    {'icon': Icons.support_agent, 'label': 'خدمة العملاء'},
    {'icon': Icons.widgets, 'label': 'Delni Services'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخدمات'),
        backgroundColor: Colors.amber[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: services.map((service) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // يمكن لاحقًا فتح صفحة خاصة لكل خدمة
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم اختيار: ${service['label']}')),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(service['icon'], size: 48, color: Colors.amber[800]),
                    const SizedBox(height: 10),
                    Text(
                      service['label'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
