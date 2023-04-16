import 'package:flutter/material.dart';
import 'package:tripify/models/tour_operator_response_model.dart';
import 'package:tripify/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TourOperatorSceen extends StatefulWidget {
  static const String routeName = '/tour_operator';
  const TourOperatorSceen({super.key});

  @override
  State<TourOperatorSceen> createState() => _TourOperatorSceenState();
}

class _TourOperatorSceenState extends State<TourOperatorSceen> {
  List<TourOperators> tourOp = [];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(params);
  }

  void _launchWeb(String website) async {
    await launchUrl(Uri.parse(website), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Tour Operator',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future:
              APIService.tourOperatorAll().then((value) => {tourOp = value}),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * .13,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: SizedBox(
                            child: Image.network(
                              tourOp.first.image.secureUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                tourOp.first.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tourOp.first.description,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blue, size: 18),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '${tourOp.first.address.street}, ${tourOp.first.address.city}, ${tourOp.first.address.state} ${tourOp.first.address.zip}',
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Contact',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    color: Colors.lightBlue, size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  tourOp.first.contact.name,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Colors.green, size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  tourOp.first.contact.phone,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Colors.redAccent, size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  tourOp.first.contact.email,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    _makePhoneCall(tourOp.first.contact.phone);
                                  },
                                  color: Colors.green[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.call,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Call',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    _launchEmail(tourOp.first.contact.email);
                                  },
                                  color: Colors.deepOrange[400],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.mail,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Mail',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    _launchWeb(
                                        tourOp.first.tariffDocument.secureUrl);
                                  },
                                  color: Colors.lightBlue[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'View tarrif',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
