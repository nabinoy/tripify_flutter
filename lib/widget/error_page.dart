import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1473116763249-2faaef81ccda?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1196&q=80',
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 350,
                  color: Colors.black12,
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            const Icon(
                              MdiIcons.heart,
                              size: 24,
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Port Blair',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 23),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Koh Chang Tai, Thailand",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                RatingBar(3),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "4",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        height: 50,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                FeaturesTile(
                  icon: Icon(Icons.wifi, color: Color(0xff5A6C64)),
                  label: "Free Wi-Fi",
                ),
                FeaturesTile(
                  icon: Icon(Icons.beach_access, color: Color(0xff5A6C64)),
                  label: "Sand Beach",
                ),
                FeaturesTile(
                  icon: Icon(Icons.card_travel, color: Color(0xff5A6C64)),
                  label: "First Coastline",
                ),
                FeaturesTile(
                  icon: Icon(Icons.local_drink, color: Color(0xff5A6C64)),
                  label: "bar and Resturant",
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [DetailsCard(), DetailsCard()],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut scelerisque arcu quis eros auctor, eu dapibus urna congue. Nunc nisi diam, semper maximus risus dignissim, semper maximus nibh. Sed finibus ipsum eu erat finibus efficitur. ",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff879D95)),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 2,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const ImageListTile(
                      imgUrl:
                          'https://images.unsplash.com/photo-1473116763249-2faaef81ccda?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1196&q=80',
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xffE9F4F9),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xffD5E6F2),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/card1.png",
                  height: 30,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Booking",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5A6C64)),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "8.0/10",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5A6C64)),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            " Based on 30 reviews",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff879D95)),
          ),
        ],
      ),
    );
  }
}

class FeaturesTile extends StatelessWidget {
  final Icon icon;
  final String label;
  const FeaturesTile({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xff5A6C64).withOpacity(0.5)),
                borderRadius: BorderRadius.circular(40)),
            child: icon,
          ),
          const SizedBox(
            height: 9,
          ),
          SizedBox(
              width: 70,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff5A6C64)),
              ))
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int rating;
  const RatingBar(this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: rating >= 1 ? Colors.white70 : Colors.white30,
        ),
        const SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 2 ? Colors.white70 : Colors.white30,
        ),
        const SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 3 ? Colors.white70 : Colors.white30,
        ),
        const SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 4 ? Colors.white70 : Colors.white30,
        ),
        const SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 5 ? Colors.white70 : Colors.white30,
        ),
      ],
    );
  }
}

class ImageListTile extends StatelessWidget {
  final String imgUrl;
  const ImageListTile({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 5000),
          imageUrl: imgUrl,
          height: 220,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
