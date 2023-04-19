import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/services/shared_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    SharedService.getSharedLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: randomAvatar(SharedService.name, height: 70, width: 70),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              SharedService.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              SharedService.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                  foregroundColor: const Color.fromARGB(194, 0, 0, 0)),
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(width: 20),
                  Expanded(child: Text('Edit name')),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                  foregroundColor: const Color.fromARGB(194, 0, 0, 0)),
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.lock_reset_outlined),
                  SizedBox(width: 20),
                  Expanded(child: Text('Change password')),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                foregroundColor: const Color.fromARGB(194, 0, 0, 0),
              ),
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.logout),
                  SizedBox(width: 20),
                  Expanded(child: Text('Log out')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
