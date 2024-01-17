import 'package:flutter/material.dart';
import '../Models/Place.dart';
import '../ViewModel/PlaceViewModel.dart';
import 'DetailsPage.dart'; // Import the DetailsPage

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> cities = [
    'Tunis',
    'Ariana',
    'Ben Arous',
    'Manouba',
    'Nabeul',
    'Zaghouan',
    'Bizerte',
    'Béja',
    'Jendouba',
    'Le Kef',
    'Siliana',
    'Kairouan',
    'Kasserine',
    'Sidi Bouzid',
    'Sfax',
    'Gabès',
    'Medenine',
    'Tataouine',
    'Gafsa',
    'Tozeur',
    'Kébili',
    'Monastir',
    'Mahdia',
    'Sousse',
  ];

  String selectedCity = 'Tunis'; // Default city
  List<Place> places = []; // List to store places
  final PlaceViewModel viewModel = PlaceViewModel(
    apiUrl: 'https://api.opentripmap.com/0.1/en/places/radius?apikey=5ae2e3f221c38a28845f05b6e1e72f6e6fae9bc6a9473af209e333f9&radius=5000&lon=10.63699&lat=35.82539&rate=3&format=json',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedCity,
                  items: cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedCity = value;
                      });
                    }
                  },
                ),
                Text(
                  'curren location', // Replace this with the additional text you want to add
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: viewModel.getPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            places = snapshot.data as List<Place>;

            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      places[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${places[index].kinds}',
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${places[index].dist.toStringAsFixed(2)} m',
                          ),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.all(16),
                    onTap: () {
                      // Navigate to the details page when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(place: places[index]),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: () async {
                        // Call the method to add the place to favorites
                        await viewModel.addToFavorites(places[index]);

                        // Show a snackbar to indicate the place was added to favorites
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${places[index].name} added to favorites'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}