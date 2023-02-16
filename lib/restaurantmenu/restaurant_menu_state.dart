part of 'restaurant_menu_bloc.dart';

class RestaurantMenuInitial extends RestaurantMenuState {}

enum RestaurantMenuStatus {
  initial,
  success,
  failure,
}

class RestaurantMenuState extends Equatable {
  const RestaurantMenuState({
    this.restaurante = null,
    this.id = "",
    this.status = RestaurantMenuStatus.initial,
    this.platos = const <PlatoGeneric>[],
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  final String id;
  final int currentPage;
  final RestaurantMenuStatus status;
  final List<PlatoGeneric> platos;
  final bool hasReachedMax;
  final RestauranteDetailResult? restaurante;

  RestaurantMenuState copyWith(
      {String? id,
      RestauranteDetailResult? restaurante,
      RestaurantMenuStatus? status,
      List<PlatoGeneric>? platos,
      bool? hasReachedMax,
      int? currentPage}) {
    return RestaurantMenuState(
        id: id ?? this.id,
        restaurante: restaurante ?? this.restaurante,
        status: status ?? this.status,
        platos: platos ?? this.platos,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, restaurante: ${restaurante} }''';
  }

  @override
  List<Object> get props =>
      [id, restaurante!, status, platos, hasReachedMax, currentPage];
}
