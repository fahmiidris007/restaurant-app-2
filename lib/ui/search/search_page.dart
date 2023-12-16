import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search_restaurant_provider.dart';
import 'package:restaurant_app/theme/styles.dart';
import 'package:restaurant_app/widget/card_restaurant.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Restaurant'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Search Restaurant',
                    floatingLabelStyle: const TextStyle(color: secondaryColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<SearchRestaurantProvider>()
                            .search(state.query);
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(
                      () {
                        state.query = value;
                        context
                            .read<SearchRestaurantProvider>()
                            .search(state.query);
                      },
                    );
                  },
                ),
                if (state.state == ResultState.loading)
                  const Center(child: CircularProgressIndicator())
                else if (state.state == ResultState.hasData)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = state.result.restaurants[index];
                        return CardRestaurant(restaurant: restaurant);
                      },
                    ),
                  ),
                if (state.state == ResultState.noData)
                  Expanded(child: Center(child: Text(state.message))),
                if (state.state == ResultState.error)
                  Expanded(child: Center(child: Text(state.message))),
              ],
            ),
          ),
        );
      },
    );
  }
}
