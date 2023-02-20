part of 'manage_restaurant_bloc.dart';

abstract class ManageRestaurantEvent extends Equatable {
  const ManageRestaurantEvent();

  @override
  List<Object> get props => [];
}

class RestaurantFetched extends ManageRestaurantEvent {
  RestaurantFetched(this.restaurantId);
  String restaurantId;
}
