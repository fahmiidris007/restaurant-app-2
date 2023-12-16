import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class DetailRestaurantProvider extends ChangeNotifier {
  late final ApiService apiService;
  final String id;

  DetailRestaurantProvider({required this.apiService, this.id = ''}) {
    fetchDetailRestaurant(id);
  }

  late DetailRestaurant _detailRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurant get result => _detailRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchDetailRestaurant(String id) async {
    try {
      if (id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data Restaurant Found';
      }
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.detailRestaurant(id);
      _state = ResultState.hasData;
      notifyListeners();
      return _detailRestaurant = restaurant;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Check Your Internet Connection !';
    }
  }
}
