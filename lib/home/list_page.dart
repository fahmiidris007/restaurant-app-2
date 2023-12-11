import 'package:flutter/material.dart';
import 'package:restaurant_app/data/restaurant.dart';

import '../detail/detail_page.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant App'),
        ),
        body: Column(children: [
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
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/local_restaurant.json'),
                builder: (context, snapshot) {
                  final Restaurant restaurants =
                      restaurantFromJson(snapshot.data);
                  final results = restaurants.restaurants
                      .where((restaurant) =>
                          restaurant.name.toLowerCase().contains(searchQuery))
                      .toList();
                  if (results.isEmpty) {
                    return const Center(
                        child: Text('No restaurants data available'));
                  } else {
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantItem(context, results[index]);
                      },
                    );
                  }
                }),
          )
        ]));
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantElement restaurant) {
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Hero(
            tag: restaurant.pictureId,
            child: Image.network(
              restaurant.pictureId,
              width: 100,
              errorBuilder: (ctx, error, _) =>
                  const Center(child: Icon(Icons.error)),
            )),
        title: Text(restaurant.name),
        subtitle: Row(
          children: <Widget>[
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 5),
            Text(restaurant.rating.toString()),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetailPage.routeName,
              arguments: restaurant);
        });
  }
}
