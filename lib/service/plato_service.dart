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
}
