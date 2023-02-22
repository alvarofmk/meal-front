import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:front/model/restaurante_request.dart';

import '../config/locator.dart';
import '../model/restaurante_detail.dart';
import '../service/restaurant_service.dart';
import 'manage_restaurant_event.dart';

part 'manage_restaurant_state.dart';

class ManageRestaurantBloc
    extends Bloc<ManageRestaurantEvent, ManageRestaurantState> {
  late final RestaurantService _restaurantService;

  ManageRestaurantBloc() : super(ManageRestaurantInitial()) {
    _restaurantService = getIt<RestaurantService>();
    on<RestaurantFetched>(
      _onRestaurantFetched,
    );
    on<DeleteRestaurantEvent>(_onDeleteRestaurantEvent);
    on<EditRestaurant>(_onEditRestaurant);
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

  FutureOr<void> _onDeleteRestaurantEvent(
      DeleteRestaurantEvent event, Emitter<ManageRestaurantState> emit) async {
    try {
      await _restaurantService.deleteById(event.restaurantId);
      return emit(
        state.copyWith(status: ManageRestaurantStatus.deleted),
      );
    } catch (_) {
      emit(state.copyWith(status: ManageRestaurantStatus.success));
    }
  }

  FutureOr<void> _onEditRestaurant(
      EditRestaurant event, Emitter<ManageRestaurantState> emit) async {
    try {
      final response =
          await _restaurantService.edit(event.restaurantId, event.editData);
      return emit(
        state.copyWith(
            restaurante: response, status: ManageRestaurantStatus.editSuccess),
      );
    } catch (_) {
      emit(state.copyWith(status: ManageRestaurantStatus.failure));
    }
  }
}
