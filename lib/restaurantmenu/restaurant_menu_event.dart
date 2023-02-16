part of 'restaurant_menu_bloc.dart';

abstract class RestaurantMenuEvent extends Equatable {
  const RestaurantMenuEvent();

  @override
  List<Object> get props => [];
}

class NavigatedToRestaurant extends RestaurantMenuEvent {
  NavigatedToRestaurant(restaurantId);
}
