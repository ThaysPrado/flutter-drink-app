import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:drink_app/models/drink.dart';
import 'package:drink_app/models/drink_option.dart';

class DrinkApiProvider {

  static const baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1/';

  Future<List<DrinkOption>> getDrinkOptions(String search) async {

    String url = '${baseUrl}filter.php?${search}';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body)['drinks'];
      List<DrinkOption> listOfUsers = items.map<DrinkOption>((json) {
        return DrinkOption.fromJson(json);
      }).toList();
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }

  }

  Future<Drink> getDrinkDetails(String id) async {

    String url = '${baseUrl}lookup.php?i=${id}';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      Drink drinkDetails = Drink.fromJson(items);
      return drinkDetails;
    } else {
      throw Exception('Failed to load internet');
    }

  }

  Future<Drink> getDrinkRandom() async {

    String url = '${baseUrl}random.php';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      Drink drink = Drink.fromJson(item);
      return drink;
    } else {
      throw Exception('Failed to load internet');
    }
  }

}