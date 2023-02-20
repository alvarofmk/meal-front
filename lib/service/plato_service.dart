import 'package:front/model/plato_detail_result.dart';
import 'package:front/model/plato_list_result.dart';
import 'package:front/repository/plato_repository.dart';
import 'package:front/repository/restaurant_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/RestauranteListResult.dart';

@singleton
class PlatoService {
  late PlatoRepository _platoRepository;

  PlatoService() {
    _platoRepository = GetIt.I.get<PlatoRepository>();
  }

  Future<PlatoListResult> getByRestaurant(String restaurantId, int page) async {
    return _platoRepository.getByRestaurant(restaurantId, page);
  }

  Future<PlatoDetailResult> getDetails(String platoId) async {
    return _platoRepository.getDetails(platoId);
  }

  Future<PlatoDetailResult> rate(
      String platoId, double nota, String? comentario) async {
    return _platoRepository.rate(platoId, nota, comentario);
  }
}
