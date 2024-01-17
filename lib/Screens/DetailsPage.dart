import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/Place.dart';

class DetailsPage extends StatefulWidget {
  final Place place;

  DetailsPage({required this.place});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Map<String, dynamic> placeDetails = {};

  @override
  void initState() {
    super.initState();
    // Fetch details of the selected place using the provided placeId
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.opentripmap.com/0.1/en/places/xid/${widget.place.xid}?apikey=5ae2e3f221c38a28845f05b6e1e72f6e6fae9bc6a9473af209e333f9',
        ),
      );

      if (response.statusCode == 200) {
        placeDetails = json.decode(response.body);
        setState(() {});
      } else {
        print('Error fetching place details. Status code: ${response.statusCode}');
        // Handle the error as needed
      }
    } catch (e) {
      print('Error fetching place details: $e');
      // Handle the error as needed
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: placeDetails.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(

                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(placeDetails['preview']['source']),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(' ${placeDetails['name']}'),
              SizedBox(height: 16),
              Text('${placeDetails['kinds']}'),
              SizedBox(height: 16),
              Text(
                ' ${placeDetails['address']['city']}, ${placeDetails['address']['country']}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(' ${placeDetails['wikipedia_extracts']['text']}'),
              GestureDetector(
                child: Text(
                  'Visit Wikipedia ',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}