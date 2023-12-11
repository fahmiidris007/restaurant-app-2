import 'package:flutter/material.dart';
import 'package:restaurant_app/data/restaurant.dart';
import 'package:restaurant_app/theme/styles.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final RestaurantElement restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    if (restaurant.id.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Restaurant data is not available'),
        ),
      );
    } else{
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double percentSpace =
                    ((constraints.maxHeight - kToolbarHeight) /
                        (200 - kToolbarHeight));
                return FlexibleSpaceBar(
                  centerTitle: percentSpace > 0.5,
                  titlePadding: EdgeInsets.symmetric(
                      horizontal: percentSpace > 0.5 ? 0 : 72, vertical: 16),
                  background: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                      restaurant.pictureId,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    restaurant.name,
                    style: TextStyle(
                      color: percentSpace > 0.5 ? primaryColor : onPrimaryColor,
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
                      Text(restaurant.description, textAlign: TextAlign.justify,),
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
                            return _buildDrinkItem(
                                context, restaurant.menus.drinks[index]);
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
    );}
  }

  Widget _buildFoodItem(BuildContext context, Drink food) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/food.png', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              // Add padding around the text
              child: Text(
                food.name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinkItem(BuildContext context, Drink drink) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/drink.png', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              // Add padding around the text
              child: Text(
                drink.name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
