import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/review_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class PostReviewRestaurantProvider extends ChangeNotifier {
  late final ApiService apiService;
  String id;
  String name;
  String review;

  PostReviewRestaurantProvider({required this.apiService,
    this.id = '',
    this.name = '',
    this.review = ''}) {
    _postReviewRestaurant(id, name, review);
  }

  late ReviewRestaurant _reviewRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ReviewRestaurant get result => _reviewRestaurant;

  ResultState get state => _state;

  Future<dynamic> _postReviewRestaurant(String id, String name,
      String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.reviewRestaurant(id, name, review);
      if (restaurant.customerReviews.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _reviewRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}