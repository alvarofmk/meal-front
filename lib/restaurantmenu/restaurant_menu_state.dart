part of 'restaurant_menu_bloc.dart';

abstract class RestaurantMenuState extends Equatable {
  const RestaurantMenuState();
  
  @override
  List<Object> get props => [];
}

class RestaurantMenuInitial extends RestaurantMenuState {}
