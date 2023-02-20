import 'dart:convert';

import 'package:front/model/restaurante_detail.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/RestauranteListResult.dart';
import '../rest_client/rest_client.dart';

const String baseUrl = "/restaurante/";

@singleton
class RestaurantRepository {
  late RestClient _client;

  RestaurantRepository() {
    _client = GetIt.I.get<RestClient>();
  }

  Future<RestauranteListResult> getRestaurantPage(int page) async {
    String url = baseUrl + "?page=${page}";

    var jsonResponse = await _client.get(url);
    return RestauranteListResult.fromJson(jsonDecode(jsonResponse));
  }

  Future<RestauranteDetailResult> getRestaurantDetails(
      String restaurantId) async {
    String url = baseUrl + restaurantId;

    var jsonResponse = await _client.get(url);
    return RestauranteDetailResult.fromJson(jsonDecode(jsonResponse));
  }

  Future<RestauranteListResult> getManagedRestaurants() async {
    String url = baseUrl + "managed";

    var jsonResponse = await _client.get(url);
    return RestauranteListResult.fromJson(jsonDecode(jsonResponse));
  }

  void deleteById(String restaurantId) async {
    String url = baseUrl + "${restaurantId}";
    await _client.delete(url);
  }
}
