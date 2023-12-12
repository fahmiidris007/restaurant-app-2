import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/widget/card_restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  String searchQuery = '';
  late Future<ListRestaurant> _listRestaurant;

  @override
  void initState() {
    super.initState();
    _listRestaurant = ApiService().listRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurant...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(
                  () {
                    searchQuery = value.toLowerCase();
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<ListRestaurant>(
              future: _listRestaurant,
              builder: (context, AsyncSnapshot<ListRestaurant> snapshot) {
                var state = snapshot.connectionState;
                if (state != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    var restaurants = snapshot.data!.restaurants;
                    if (searchQuery.isNotEmpty) {
                      restaurants = restaurants
                          .where(
                            (restaurant) => restaurant.name
                                .toLowerCase()
                                .contains(searchQuery),
                          )
                          .toList();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = restaurants[index];
                        return CardRestaurant(
                          restaurant: restaurant,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Material(
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  } else {
                    return const Material(child: Text(''));
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
