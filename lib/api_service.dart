import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ad_model.dart';

class ApiService {
  static const String baseUrl = 'http://157.245.19.128:8000/api';
  static Future<List<Ad>> fetchAds() async {
    final response = await http.get(Uri.parse('$baseUrl/ads'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Ad.fromJson(item)).toList();
    } else {
      throw Exception('فشل في جلب الإعلانات');
    }
  }

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

  static Future<List<Ad>> searchAds(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/ads?search=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Ad.fromJson(item)).toList();
    } else {
      throw Exception('فشل في البحث');
    }
  }
}
