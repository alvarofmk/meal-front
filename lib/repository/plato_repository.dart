import 'dart:convert';

import 'package:front/model/plato_detail_result.dart';
import 'package:front/model/rating.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/plato_list_result.dart';
import '../rest_client/rest_client.dart';

const String baseUrl = "/plato/";

@singleton
class PlatoRepository {
  late RestClient _client;

  PlatoRepository() {
    _client = GetIt.I.get<RestClient>();
  }

  Future<PlatoListResult> getByRestaurant(String restaurantId, int page) async {
    String url = baseUrl + "restaurante/${restaurantId}?page=${page}";

    var jsonResponse = await _client.get(url);
    return PlatoListResult.fromJson(jsonDecode(jsonResponse));
  }

  Future<PlatoDetailResult> getDetails(String platoId) async {
    String url = baseUrl + platoId;

    var jsonResponse = await _client.get(url);
    return PlatoDetailResult.fromJson(jsonDecode(jsonResponse));
  }

  Future<PlatoDetailResult> rate(
      String platoId, double nota, String? comentario) async {
    String url = baseUrl + "rate/${platoId}";

    var jsonResponse = await _client.post(
        url, RateRequest(nota: nota, comentario: comentario));
    return PlatoDetailResult.fromJson(jsonDecode(jsonResponse));
  }
}
