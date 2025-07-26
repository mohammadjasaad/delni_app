import 'package:flutter/material.dart';
import 'package:delni_app/ad_model.dart';
import 'package:delni_app/api_service.dart';
import 'package:delni_app/ad_details_page.dart';

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  List<Ad> _latestAds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLatestAds();
  }

  Future<void> _fetchLatestAds() async {
    final ads = await ApiService.fetchAds();
    setState(() {
      _latestAds = ads.take(10).toList(); // عرض أحدث 10 إعلانات فقط
      _loading = false;
    });
  }

  Widget _buildAdCard(Ad ad) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdDetailsPage(ad: ad)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ad.imageUrl.isNotEmpty
                ? Image.network(
                    ad.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 160,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ad.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${ad.price} ل.س',
                style: const TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أحدث الإعلانات'),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _latestAds.isEmpty
              ? const Center(child: Text('لا توجد إعلانات حالياً'))
              : ListView.builder(
                  itemCount: _latestAds.length,
                  itemBuilder: (context, index) => _buildAdCard(_latestAds[index]),
                ),
    );
  }
}
