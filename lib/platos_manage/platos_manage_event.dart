part of 'platos_manage_bloc.dart';

abstract class PlatosManageEvent extends Equatable {
  const PlatosManageEvent();

  @override
  List<Object> get props => [];
}

class PlatosFetchedEvent extends PlatosManageEvent {
  PlatosFetchedEvent(this.restaurantId);
  String restaurantId;
}

class DeletePlatoEvent extends PlatosManageEvent {
  DeletePlatoEvent(this.platoId);
  String platoId;
}
