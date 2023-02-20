import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../config/locator.dart';
import '../model/restaurante_detail.dart';
import '../service/restaurant_service.dart';

part 'manage_restaurant_event.dart';
part 'manage_restaurant_state.dart';

class ManageRestaurantBloc
    extends Bloc<ManageRestaurantEvent, ManageRestaurantState> {
  late final RestaurantService _restaurantService;

  ManageRestaurantBloc() : super(ManageRestaurantInitial()) {
    _restaurantService = getIt<RestaurantService>();
    on<RestaurantFetched>(
      _onRestaurantFetched,
    );
  }

  Future<void> _onRestaurantFetched(
    RestaurantFetched event,
    Emitter<ManageRestaurantState> emit,
  ) async {
    try {
      if (state.status == ManageRestaurantStatus.initial) {
        final restauranteDetails =
            await _restaurantService.getRestaurantDetails(event.restaurantId);
        return emit(
          state.copyWith(
              id: event.restaurantId,
              restaurante: restauranteDetails,
              status: ManageRestaurantStatus.success),
        );
      }
    } catch (_) {
      emit(state.copyWith(
          id: event.restaurantId, status: ManageRestaurantStatus.failure));
    }
  }
}
