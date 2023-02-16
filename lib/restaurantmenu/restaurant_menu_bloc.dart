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
      transformer: throttleDroppable(throttleDuration),
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
      final platos = await _platoService.getByRestaurant(
          event.restaurantId, state.currentPage + 1);
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
      emit(state.copyWith(
          id: event.restaurantId, status: RestaurantMenuStatus.failure));
    }
  }
}
