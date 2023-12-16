import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class SearchRestaurantProvider extends ChangeNotifier {
  late final ApiService apiService;
  String query;

  SearchRestaurantProvider({required this.apiService, this.query = ''}) {
    _state = ResultState.noData;
    search('');
  }

  late SearchRestaurant _searchRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  SearchRestaurant get result => _searchRestaurant;

  ResultState get state => _state;

  Future<dynamic> search(String query) async {
    _fetchSearchRestaurant(query);
  }

  Future<dynamic> _fetchSearchRestaurant(String query) async {
    try {
      if (query.isEmpty) {
        _state = ResultState.noData;
        _searchRestaurant = SearchRestaurant(restaurants: []);
        notifyListeners();
        return _message = 'No Data Restaurant Found';
      }

      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(
        query.toLowerCase(),
      );
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        _searchRestaurant = SearchRestaurant(restaurants: []);
        notifyListeners();
        return _message = 'No Data Restaurant Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      _searchRestaurant = SearchRestaurant(restaurants: []);
      notifyListeners();
      return _message = 'Check Your Internet Connection !';
    }
  }
}
