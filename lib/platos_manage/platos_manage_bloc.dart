import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../config/locator.dart';
import '../model/plato_list_result.dart';
import '../service/plato_service.dart';

part 'platos_manage_event.dart';
part 'platos_manage_state.dart';

class PlatosManageBloc extends Bloc<PlatosManageEvent, PlatosManageState> {
  late final PlatoService _platoService;
  PlatosManageBloc() : super(PlatosManageInitial()) {
    _platoService = getIt<PlatoService>();
    on<PlatosFetchedEvent>(
      _onPlatosFetchedEvent,
    );
    on<DeletePlatoEvent>(
      _onDeletePlatoEventEvent,
    );
  }

  FutureOr<void> _onPlatosFetchedEvent(
      PlatosFetchedEvent event, Emitter<PlatosManageState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PlatosManageStatus.initial) {
        final platos =
            await _platoService.getByRestaurant(event.restaurantId, 0);
        return emit(
          state.copyWith(
              restaurantId: event.restaurantId,
              status: PlatosManageStatus.success,
              platos: platos.contenido!,
              hasReachedMax: platos.paginaActual! + 1 >= platos.numeroPaginas!,
              currentPage: state.currentPage + 1),
        );
      }
      final platos = await _platoService.getByRestaurant(
          state.restaurantId, state.currentPage + 1);
      platos.contenido!.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                  status: PlatosManageStatus.success,
                  platos: List.of(state.platos)..addAll(platos.contenido!),
                  hasReachedMax:
                      platos.paginaActual! + 1 >= platos.numeroPaginas!,
                  currentPage: state.currentPage + 1),
            );
    } catch (_) {
      emit(state.copyWith(status: PlatosManageStatus.failure));
    }
  }

  FutureOr<void> _onDeletePlatoEventEvent(
      DeletePlatoEvent event, Emitter<PlatosManageState> emit) async {
    try {
      await _platoService.deleteById(event.platoId);
      final platos = await _platoService.getByRestaurant(state.restaurantId, 0);
      return emit(
        state.copyWith(
            restaurantId: state.restaurantId,
            status: PlatosManageStatus.success,
            platos: platos.contenido!,
            hasReachedMax: platos.paginaActual! + 1 >= platos.numeroPaginas!,
            currentPage: 1),
      );
    } catch (_) {
      emit(state.copyWith(status: PlatosManageStatus.failure));
    }
  }
}
