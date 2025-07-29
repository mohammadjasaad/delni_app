import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'ad_model.dart';

class ApiService {
  static const String baseUrl = 'http://157.245.19.128:8000/api';

  // ✅ 1. جلب الإعلانات
  static Future<List<Ad>> fetchAds() async {
    final response = await http.get(Uri.parse('$baseUrl/ads'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Ad.fromJson(item)).toList();
    } else {
      throw Exception('فشل في جلب الإعلانات');
    }
  }

  // ✅ 2. حذف إعلان
  static Future<bool> deleteAd({
    required int adId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/ads/$adId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  // ✅ 3. البحث في الإعلانات
  static Future<List<Ad>> searchAds(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/ads?search=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Ad.fromJson(item)).toList();
    } else {
      throw Exception('فشل في البحث');
    }
  }

  // ✅ 4. إضافة إعلان جديد مع صور متعددة
  static Future<bool> createAd({
    required String title,
    required String description,
    required String price,
    required String city,
    required String category,
    required int userId,
    required List<XFile> images,
    required String token,
  }) async {
    var uri = Uri.parse('$baseUrl/ads');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['city'] = city;
    request.fields['category'] = category;
    request.fields['user_id'] = userId.toString();

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // ✅ الصور المتعددة
    for (var image in images) {
      var file = await http.MultipartFile.fromPath(
        'images[]',
        image.path,
        filename: basename(image.path),
      );
      request.files.add(file);
    }

    var response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
