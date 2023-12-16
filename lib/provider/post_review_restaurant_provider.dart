import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/review_restaurant.dart';

enum ResultState { loading, hasData, error }

class PostReviewRestaurantProvider extends ChangeNotifier {
  late final ApiService apiService;
  final String id;

  PostReviewRestaurantProvider({required this.apiService, required this.id});

  late ReviewRestaurant _reviewRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ReviewRestaurant get result => _reviewRestaurant;

  ResultState get state => _state;

  Future<dynamic> postReviewRestaurant(String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final reviewRestaurant =
          await apiService.postReviewRestaurant(id, name, review);
      _state = ResultState.hasData;
      notifyListeners();
      return _reviewRestaurant = reviewRestaurant;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Check Your Internet Connection !';
    }
  }
}
