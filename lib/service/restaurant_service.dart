import 'package:front/repository/restaurant_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/RestauranteListResult.dart';

@singleton
class RestaurantService {
  late RestaurantRepository _restaurantRepository;

  RestaurantService() {
    _restaurantRepository = GetIt.I.get<RestaurantRepository>();
  }

  Future<RestauranteListResult> getRestaurantPage(int page) async {
    return _restaurantRepository.getRestaurantPage(page);
  }
}
