import 'package:flutter/material.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/services/api_service.dart';

class ItineraryDetails extends StatefulWidget {
  static const String routeName = '/itinerary_detail';
  const ItineraryDetails({super.key});

  @override
  State<ItineraryDetails> createState() => _ItineraryDetailsState();
}

class _ItineraryDetailsState extends State<ItineraryDetails> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final ItineraryModel model = arguments[0];
    final List<String> categories = arguments[1];
    final List<String> island = arguments[2];

    late List<List<Places2>> itineraryPlace;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.wait([
          APIService.itineraryAll(model, categories, island)
              .then((value) => {itineraryPlace = value}),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                      'Your itinerary for ${itineraryPlace.length.toString()} days!')
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
