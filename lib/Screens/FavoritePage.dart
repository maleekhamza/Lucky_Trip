import 'package:flutter/material.dart';
import '../Models/Place.dart';
import '../ViewModel/PlaceViewModel.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favorites = [];
  final PlaceViewModel viewModel = PlaceViewModel(
    apiUrl:
    'https://api.opentripmap.com/0.1/en/places/radius?apikey=5ae2e3f221c38a28845f05b6e1e72f6e6fae9bc6a9473af209e333f9&radius=5000&lon=10.63699&lat=35.82539&rate=3&format=json',
  );

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    List<String> fetchedFavorites = await viewModel.getFavorites();
    setState(() {
      favorites = fetchedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(favorites[index]),
              subtitle: FutureBuilder(
                future: viewModel.getPlaces(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Place> places = snapshot.data as List<Place>;
                    Place favoritePlace = places
                        .firstWhere((place) => place.name == favorites[index]);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${favoritePlace.kinds}'),
                        Text(' ${favoritePlace.dist.toStringAsFixed(2)} m'),
                      ],
                    );
                  }
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  // Remove the place from favorites
                  await viewModel.removeFromFavorites(
                    Place(name: favorites[index], xid: '', kinds: '', dist: 5,
                  ));

                  // Update the displayed favorites
                  fetchFavorites();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${favorites[index]} removed from favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}