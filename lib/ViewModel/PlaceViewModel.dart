
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Place.dart';

class PlaceViewModel {
  final String apiUrl;

  PlaceViewModel({required this.apiUrl});

  Future<List<Place>> getPlaces() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((placeData) {
        return Place(
          name: placeData['name'],
          kinds: placeData['kinds'],
            xid: placeData['xid'],
          dist: placeData['dist'].toDouble(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
  Future<void> addToFavorites(Place place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(place.name);
    await prefs.setStringList('favorites', favorites);
  }
  Future<List<String>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }
  Future<void> removeFromFavorites(Place place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(place.name)) {
      favorites.remove(place.name);
      await prefs.setStringList('favorites', favorites);
    }
  }


}