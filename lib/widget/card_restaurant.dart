import 'package:flutter/material.dart';
import 'package:restaurant_app/theme/styles.dart';
import 'package:restaurant_app/ui/detail/detail_page.dart';

import '../data/model/list_restaurant.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  static const urlImage = 'https://restaurant-api.dicoding.dev/images/small/';

  const CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   elevation: 5,
    //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //   child: Container(
    //     height: 100,
    //     child: Row(
    //       children: [
    //         Container(
    //           width: 100,
    //           height: 100,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(5),
    //               bottomLeft: Radius.circular(5),
    //             ),
    //             image: DecorationImage(
    //               image: NetworkImage(urlImage + restaurant.pictureId),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: EdgeInsets.all(10),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   restaurant.name,
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     Icon(
    //                       Icons.star,
    //                       color: Colors.yellow[700],
    //                       size: 16,
    //                     ),
    //                     SizedBox(width: 5),
    //                     Text(
    //                       restaurant.rating.toString(),
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Text(
    //                   restaurant.city,
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Material(
      color: primaryColor,
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            urlImage + restaurant.pictureId,
            width: 100,
          ),
        ),
        title: Text(
          restaurant.name,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 5),
                Text(restaurant.city),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 5),
                Text(restaurant.rating.toString()),
              ],
            )],
        ),
        onTap: () => Navigator.pushNamed(
          context,
          RestaurantDetailPage.routeName,
          arguments: restaurant.id,
        ),
      ),
    );
  }
}