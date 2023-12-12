import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/review_restaurant.dart';

class ApiService{
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<ListRestaurant> listRestaurant() async {
    final response = await http.get(Uri.parse('${_baseUrl}list'));
    if (response.statusCode == 200) {
      return ListRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list restaurant');
    }
  }

  Future<DetailRestaurant> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse('${_baseUrl}detail/$id'));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail restaurant');
    }
  }

  Future<ReviewRestaurant> reviewRestaurant(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}review'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
    );
    if (response.statusCode == 200) {
      return ReviewRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load review restaurant');
    }
  }
}