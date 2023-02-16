import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/restaurantmenu/restaurant_menu_bloc.dart';

import '../landing/landing_bloc.dart';

class RestaurantScreen extends StatelessWidget {
  RestaurantScreen({super.key, required this.restaurantId});

  String restaurantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RestaurantMenuBloc()..add(NavigatedToRestaurant(restaurantId)),
      child: RestaurantUI(),
    );
  }
}

class RestaurantUI extends StatefulWidget {
  @override
  State<RestaurantUI> createState() => _RestaurantUIState();
}

class _RestaurantUIState extends State<RestaurantUI> {
  @override
  Widget build(BuildContext context) {
    //implement
  }
}
