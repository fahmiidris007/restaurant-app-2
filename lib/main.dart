import 'package:flutter/material.dart';
import 'package:restaurant_app/splash/splash_screen.dart';
import 'package:restaurant_app/theme/styles.dart';

import 'data/restaurant.dart';
import 'detail/detail_page.dart';
import 'home/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          secondary: secondaryColor,
        ),
        textTheme: myTextTheme,
        appBarTheme: const AppBarTheme(elevation: 0)
      ),
      home: const SplashScreen(),
      routes: {
        RestaurantListPage.routeName: (context) => const RestaurantListPage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
          restaurant: ModalRoute.of(context)?.settings.arguments as RestaurantElement,
        ),
      },
    );
  }
}


