import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'restaurant_menu_event.dart';
part 'restaurant_menu_state.dart';

class RestaurantMenuBloc extends Bloc<RestaurantMenuEvent, RestaurantMenuState> {
  RestaurantMenuBloc() : super(RestaurantMenuInitial()) {
    on<RestaurantMenuEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
