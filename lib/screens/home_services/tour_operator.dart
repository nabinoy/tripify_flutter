import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/tour_operator_response_model.dart';
import 'package:tripify/screens/search/search_tour_operator.dart';
import 'package:tripify/screens/util.dart/pdf_viewer.dart';
import 'package:tripify/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/shared_service.dart';

class TourOperatorSceen extends StatefulWidget {
  static const String routeName = '/tour_operator';
  const TourOperatorSceen({super.key});

  @override
  State<TourOperatorSceen> createState() => _TourOperatorSceenState();
}

class _TourOperatorSceenState extends State<TourOperatorSceen> {
  List<TourOperators> tourOp = [];
  int page = 1;
  int isEndLoading = 1;
  int tourOpCount = 1;
  final controller = ScrollController();
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = APIService.tourOpCount().then((value) async => {
          tourOpCount = value,
          await APIService.tourOperatorAll().then((value) => {tourOp = value})
        });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    List<TourOperators> temp = [];
    page++;
    await APIService.allTourOpPagination(page.toString())
        .then((value) => {temp = value});
    setState(() {
      tourOp.addAll(temp);
    });
  }

  void _makePhoneCall(String phoneNumber) async {
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
  void dispose() {
    controller.dispose();
    super.dispose();
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
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 16, right: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${SharedService.name.split(' ').firstWhere((name) => name.length > 2)}',
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Looking for a tour operator?",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.lightBlue[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchTourOperator.routeName);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade200.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search_outlined,
                          color: Color.fromARGB(221, 55, 55, 55)),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * .0145),
                        height: MediaQuery.of(context).size.height * .06,
                        child: const Text(
                          'Search Tour operators',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (tourOp.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 85),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.alertCircleOutline,
                            size: 58,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tour operator found!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (tourOpCount <= (page * tourOpPageSize)) {
                      isEndLoading = 0;
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        controller: (isEndLoading == 0) ? null : controller,
                        itemCount: tourOp.length + isEndLoading,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < tourOp.length) {
                            return Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 5),
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
                                    radius:
                                        MediaQuery.of(context).size.width * .13,
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      child: CachedNetworkImage(
                                        imageUrl: tourOp[index].image.secureUrl,
                                        placeholder: (context, url) =>
                                            Image.memory(
                                          kTransparentImage,
                                          fit: BoxFit.cover,
                                        ),
                                        fadeInDuration:
                                            const Duration(milliseconds: 200),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            tourOp[index].name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        ExpandableText(
                                          tourOp[index].description,
                                          animation: true,
                                          expandText: 'show more',
                                          collapseText: 'show less',
                                          maxLines: 5,
                                          linkColor: Colors.blue,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.blue, size: 18),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                '${tourOp[index].address.street}, ${tourOp[index].address.city}, ${tourOp[index].address.state}, ${tourOp[index].address.zip}',
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(Icons.person,
                                                color: Colors.lightBlue,
                                                size: 18),
                                            const SizedBox(width: 5),
                                            Text(
                                              tourOp[index].contact.name,
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
                                              tourOp[index].contact.phone,
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
                                                color: Colors.redAccent,
                                                size: 18),
                                            const SizedBox(width: 5),
                                            Text(
                                              tourOp[index].contact.email,
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                _makePhoneCall(tourOp[index]
                                                    .contact
                                                    .phone);
                                              },
                                              color: Colors.green[600],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                            MaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                _launchEmail(tourOp[index]
                                                    .contact
                                                    .email);
                                              },
                                              color: Colors.deepOrange[400],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                            MaterialButton(
                                              elevation: 0,
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    PdfViewPage.routeName,
                                                    arguments: [
                                                      tourOp[index]
                                                          .tariffDocument
                                                          .secureUrl,
                                                      'Tarrif Document'
                                                    ]);
                                              },
                                              color: Colors.lightBlue[600],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        MaterialButton(
                                          elevation: 0,
                                          onPressed: () {
                                            _launchWeb('https://google.com');
                                          },
                                          color: Colors.lightBlue[800],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                MdiIcons.web,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Get a quote',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              height: 100,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ));
  }
}
