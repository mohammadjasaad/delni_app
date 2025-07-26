import 'package:flutter/material.dart';
import 'ad_model.dart';
import 'l10n/app_localizations.dart';

class AdDetailsPage extends StatelessWidget {
  final Ad ad;

  const AdDetailsPage({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('ad_details')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الصورة الرئيسية
            if (ad.image != null && ad.image.isNotEmpty)
              Image.network(
                'http://157.245.19.128:8000/storage/${ad.image}',
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),

            // التفاصيل
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            '${ad.price} ₺',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_city),
                          const SizedBox(width: 8),
                          Text(ad.city),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category),
                          const SizedBox(width: 8),
                          Text(ad.category),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        t.translate('description'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ad.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (ad.email != null) ...[
                        const Divider(height: 32),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined),
                            const SizedBox(width: 8),
                            Text(ad.email ?? ''),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
