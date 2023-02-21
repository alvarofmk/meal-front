import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:front/service/plato_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../config/locator.dart';
import '../model/plato_list_result.dart';
import '../model/restaurante_detail.dart';
import '../service/restaurant_service.dart';

part 'restaurant_menu_event.dart';
part 'restaurant_menu_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class RestaurantMenuBloc
    extends Bloc<RestaurantMenuEvent, RestaurantMenuState> {
  late final RestaurantService _restaurantService;
  late final PlatoService _platoService;

  RestaurantMenuBloc() : super(RestaurantMenuInitial()) {
    _restaurantService = getIt<RestaurantService>();
    _platoService = getIt<PlatoService>();
    on<RestaurantFetched>(
      _onRestaurantFetched,
    );
    on<NextPlatosFetched>(
      _onNextPlatosFetched,
    );
    on<SearchPlatosEvent>(
      _onSearchPlatosEvent,
    );
  }

  Future<void> _onRestaurantFetched(
    RestaurantFetched event,
    Emitter<RestaurantMenuState> emit,
  ) async {
    try {
      if (state.status == RestaurantMenuStatus.initial) {
        final restauranteDetails =
            await _restaurantService.getRestaurantDetails(event.restaurantId);
        final platos =
            await _platoService.getByRestaurant(event.restaurantId, 0);
        return emit(
          state.copyWith(
              id: event.restaurantId,
              status: RestaurantMenuStatus.success,
              restaurante: restauranteDetails,
              platos: platos.contenido,
              hasReachedMax: false,
              currentPage: 0),
        );
      }
    } catch (_) {
      emit(state.copyWith(
          id: event.restaurantId, status: RestaurantMenuStatus.failure));
    }
  }

  FutureOr<void> _onNextPlatosFetched(
      NextPlatosFetched event, Emitter<RestaurantMenuState> emit) async {
    try {
      final platos =
          await _platoService.getByRestaurant(state.id, state.currentPage + 1);
      platos.contenido!.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                  status: RestaurantMenuStatus.success,
                  platos: List.of(state.platos)..addAll(platos.contenido!),
                  hasReachedMax: false,
                  currentPage: state.currentPage + 1),
            );
    } catch (_) {
      emit(state.copyWith(status: RestaurantMenuStatus.failure));
    }
  }

  FutureOr<void> _onSearchPlatosEvent(
      SearchPlatosEvent event, Emitter<RestaurantMenuState> emit) async {
    try {
      String searchString = "search=";
      if (event.busqueda != null) searchString += "nombre:${event.busqueda!},";
      if (event.maxPriceValue != null)
        searchString += "precio<${event.maxPriceValue!},";
      if (event.minPriceValue != null)
        searchString += "precio>${event.minPriceValue!},";
      if (event.noGluten != null)
        searchString += "sinGluten:${event.noGluten! ? 1 : 0},";
      final platos =
          await _platoService.searchByRestaurant(state.id, searchString, 0);
      return emit(
        state.copyWith(
            platos: platos.contenido, hasReachedMax: false, currentPage: 1),
      );
    } catch (_) {
      emit(state.copyWith(status: RestaurantMenuStatus.failure));
    }
  }
}
