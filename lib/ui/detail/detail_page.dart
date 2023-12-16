import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/theme/styles.dart';
import 'package:restaurant_app/ui/post_review/post_review_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailRestaurantProvider>(context, listen: false)
          .fetchDetailRestaurant(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestaurantProvider>(
      create: (_) => DetailRestaurantProvider(
        apiService: ApiService(),
        id: widget.restaurantId,
      ),
      child: Consumer<DetailRestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            var restaurant = state.result.restaurant;
            const urlImage =
                'https://restaurant-api.dicoding.dev/images/medium/';
            return Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double percentSpace =
                            ((constraints.maxHeight - kToolbarHeight) /
                                (200 - kToolbarHeight));
                        return FlexibleSpaceBar(
                          centerTitle: percentSpace > 0.5,
                          titlePadding: EdgeInsets.symmetric(
                              horizontal: percentSpace > 0.5 ? 0 : 72,
                              vertical: 16),
                          background: Hero(
                            tag: restaurant.pictureId,
                            child: Image.network(
                              urlImage + restaurant.pictureId,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            restaurant.name,
                            style: TextStyle(
                              color: percentSpace > 0.5
                                  ? primaryColor
                                  : onPrimaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(width: 5),
                                  Text(restaurant.city),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow),
                                  const SizedBox(width: 5),
                                  Text(restaurant.rating.toString()),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                restaurant.description,
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Menus',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Foods',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: restaurant.menus.foods.length,
                                  itemBuilder: (context, index) {
                                    return _buildFoodItem(
                                        context, restaurant.menus.foods[index]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Drinks',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: restaurant.menus.drinks.length,
                                  itemBuilder: (context, index) {
                                    return _buildDrinkItem(context,
                                        restaurant.menus.drinks[index]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Customer Reviews',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    PostReviewPage.routeName,
                                    arguments: restaurant.id,
                                  ).then(
                                    (result) {
                                      if (result != null && result == true) {
                                        Provider.of<DetailRestaurantProvider>(
                                                context,
                                                listen: false)
                                            .fetchDetailRestaurant(
                                                widget.restaurantId);
                                      }
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                child: const Text(
                                  'Add Review',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: onPrimaryColor),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: restaurant.customerReviews.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(restaurant
                                          .customerReviews[index].name),
                                      subtitle: Text(restaurant
                                          .customerReviews[index].review),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Please try again later'),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFoodItem(BuildContext context, Category food) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/food.png', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Text(food.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: primaryColor,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinkItem(BuildContext context, Category drink) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/drink.png', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Text(
                drink.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
