import 'package:flutter/material.dart';
import 'package:luckytripapp/Screens/HomePage.dart';
import 'package:luckytripapp/Screens/FavoritePage.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Lucky Trip'),
            actions: [
              // Ajouter l'icône de la localisation actuelle ici
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () async {
                  // Obtenir la localisation actuelle
                  Position position = await _getCurrentLocation();

                  // Naviguer vers une nouvelle page avec les informations de localisation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPage(position: position),
                    ),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              HomePage(),
              FavoritePage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.access_time),
                text: 'Most Recent',
              ),
              Tab(
                icon: Icon(Icons.star_border),
                text: 'Favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fonction pour obtenir la localisation actuelle
Future<Position> _getCurrentLocation() async {

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

}

// Page pour afficher les informations de localisation
class LocationPage extends StatelessWidget {
  final Position position;

  LocationPage({required this.position});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: ${position.latitude}'),
            Text('Longitude: ${position.longitude}'),
          ],
        ),
      ),
    );
  }
}