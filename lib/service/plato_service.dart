import 'package:front/model/plato_detail_result.dart';
import 'package:front/model/plato_list_result.dart';
import 'package:front/model/plato_request.dart';
import 'package:front/repository/plato_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class PlatoService {
  late PlatoRepository _platoRepository;

  PlatoService() {
    _platoRepository = GetIt.I.get<PlatoRepository>();
  }

  Future<PlatoListResult> getByRestaurant(String restaurantId, int page) async {
    return _platoRepository.getByRestaurant(restaurantId, page, "search=");
  }

  Future<PlatoDetailResult> getDetails(String platoId) async {
    return _platoRepository.getDetails(platoId);
  }

  Future<PlatoDetailResult> rate(
      String platoId, double nota, String? comentario) async {
    return _platoRepository.rate(platoId, nota, comentario);
  }

  Future<void> deleteById(String platoId) async {
    return _platoRepository.deleteById(platoId);
  }

  Future<PlatoListResult> searchByRestaurant(
      String id, String searchString, int page) async {
    return _platoRepository.getByRestaurant(id, page, searchString);
  }

  Future<PlatoDetailResult> edit(
      String platoId, PlatoRequest platoRequest) async {
    return _platoRepository.edit(platoId, platoRequest);
  }
}
