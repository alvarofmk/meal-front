part of 'platodetail_bloc.dart';

abstract class PlatodetailEvent extends Equatable {
  const PlatodetailEvent();

  @override
  List<Object> get props => [];
}

class PlatoFetched extends PlatodetailEvent {
  PlatoFetched(this.platoId);
  String platoId;
}
