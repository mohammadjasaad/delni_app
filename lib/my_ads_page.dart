import 'package:flutter/material.dart';
import 'ad_model.dart';
import 'api_service.dart';
import 'ad_details_page.dart';

class MyAdsPage extends StatefulWidget {
  final String userToken;

  const MyAdsPage({Key? key, required this.userToken}) : super(key: key);

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  late Future<List<Ad>> _myAdsFuture;

  @override
  void initState() {
    super.initState();
    _myAdsFuture = fetchMyAds();
  }

  Future<List<Ad>> fetchMyAds() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/my-ads');

    final response = await ApiService.authenticatedGet(
      url: url,
      token: widget.userToken,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = List.from(jsonDecode(response.body));
      return data.map((json) => Ad.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل إعلاناتي');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إعلاناتي')),
      body: FutureBuilder<List<Ad>>(
        future: _myAdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('فشل تحميل الإعلانات'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد إعلانات لك بعد.'));
          }

          final myAds = snapshot.data!;
          return ListView.builder(
            itemCount: myAds.length,
            itemBuilder: (context, index) {
              final ad = myAds[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: ad.image != null
                      ? Image.network(
                          'http://127.0.0.1:8000/storage/${ad.image}',
                          width: 60,
                          fit: BoxFit.cover,
                        )
                        trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: Icon(Icons.edit, color: Colors.blue),
      onPressed: () {
        // نضيف صفحة تعديل لاحقًا
      },
    ),
    IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditAdPage(ad: ad, userToken: widget.userToken),
    ),
  );
  if (result == true) {
    setState(() {
      _myAdsFuture = fetchMyAds(); // إعادة تحميل بعد التعديل
    });
  }
},
        if (confirm == true) {
          final success = await ApiService.deleteAd(
            adId: ad.id,
            userToken: widget.userToken,
          );
          if (success) {
            setState(() {
              _myAdsFuture = fetchMyAds(); // إعادة تحميل الإعلانات
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم الحذف بنجاح')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل في الحذف')),
            );
          }
        }
      },
    ),
  ],
),

                      : Icon(Icons.image, size: 40),
                  title: Text(ad.title),
                  subtitle: Text('${ad.price} ل.س - ${ad.city}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdDetailsPage(ad: ad),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
