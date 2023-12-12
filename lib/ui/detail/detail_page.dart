import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/theme/styles.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<DetailRestaurant> _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurant = ApiService().detailRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _restaurant,
      builder: (context, AsyncSnapshot<DetailRestaurant> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            var restaurant = snapshot.data!.restaurant;
            const urlImage = 'https://restaurant-api.dicoding.dev/images/medium/';
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
                                  itemCount:
                                      restaurant.menus.foods.length,
                                  itemBuilder: (context, index) {
                                    return _buildFoodItem(context,
                                        restaurant.menus.foods[index]);
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
                                  itemCount:
                                      restaurant.menus.drinks.length,
                                  itemBuilder: (context, index) {
                                    return _buildDrinkItem(context,
                                        restaurant.menus.drinks[index]);
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
    );

    // if (widget.restaurant.id.isEmpty) {
    //   return const Scaffold(
    //     body: Center(
    //       child: Text('Restaurant data is not available'),
    //     ),
    //   );
    // } else{
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: <Widget>[
    //       SliverAppBar(
    //         expandedHeight: 200,
    //         pinned: true,
    //         flexibleSpace: LayoutBuilder(
    //           builder: (BuildContext context, BoxConstraints constraints) {
    //             double percentSpace =
    //                 ((constraints.maxHeight - kToolbarHeight) /
    //                     (200 - kToolbarHeight));
    //             return FlexibleSpaceBar(
    //               centerTitle: percentSpace > 0.5,
    //               titlePadding: EdgeInsets.symmetric(
    //                   horizontal: percentSpace > 0.5 ? 0 : 72, vertical: 16),
    //               background: Hero(
    //                 tag: widget.restaurant.pictureId,
    //                 child: Image.network(
    //                   widget.restaurant.pictureId,
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //               title: Text(
    //                 widget.restaurant.name,
    //                 style: TextStyle(
    //                   color: percentSpace > 0.5 ? primaryColor : onPrimaryColor,
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       SliverList(
    //         delegate: SliverChildListDelegate(
    //           [
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       const Icon(Icons.location_on),
    //                       const SizedBox(width: 5),
    //                       Text(widget.restaurant.city),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Row(
    //                     children: [
    //                       const Icon(Icons.star, color: Colors.yellow),
    //                       const SizedBox(width: 5),
    //                       Text(widget.restaurant.rating.toString()),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Text(widget.restaurant.description, textAlign: TextAlign.justify,),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     'Menus',
    //                     style: Theme.of(context).textTheme.titleLarge,
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     'Foods',
    //                     style: Theme.of(context).textTheme.titleMedium,
    //                   ),
    //                   const SizedBox(height: 10),
    //                   SizedBox(
    //                     height: 200,
    //                     child: ListView.builder(
    //                       scrollDirection: Axis.horizontal,
    //                       itemCount: widget.restaurant.menus.foods.length,
    //                       itemBuilder: (context, index) {
    //                         return _buildFoodItem(
    //                             context, widget.restaurant.menus.foods[index]);
    //                       },
    //                     ),
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     'Drinks',
    //                     style: Theme.of(context).textTheme.titleMedium,
    //                   ),
    //                   const SizedBox(height: 10),
    //                   SizedBox(
    //                     height: 200,
    //                     child: ListView.builder(
    //                       scrollDirection: Axis.horizontal,
    //                       itemCount: widget.restaurant.menus.drinks.length,
    //                       itemBuilder: (context, index) {
    //                         return _buildDrinkItem(
    //                             context, widget.restaurant.menus.drinks[index]);
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );}
  }

  Widget _buildFoodItem(BuildContext context, Category food) {
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

  Widget _buildDrinkItem(BuildContext context, Category drink) {
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
