import 'dart:convert';

import 'package:bhitest/core/provider/auth.dart';
import 'package:bhitest/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../core/models/user.dart';
import 'referralCode.dart';

class MainHome extends StatefulWidget {
  String? referralCode;
  MainHome({Key? key, this.referralCode}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  String? userID;
  String? usersreferralCode;
  String? referralCode;
  String? emailID;
  User? user;
  User? referralUser;
  bool isreferral = false;

  checkForReferral() async {
    final url = Uri.parse(
        'https://bhit-c7c8a-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json?orderBy="referralCode"&equalTo="${widget.referralCode}"');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      List<User> users = [];
      responseData.forEach((key, value) {
        users.add(User.fromMap(value));
      });
      setState(() {
        referralUser = users.firstWhere((element) {
          return element.userID !=
              Provider.of<Auth>(context, listen: false).userID;
        });
        if (referralUser?.userID !=
            Provider.of<Auth>(context, listen: false).userID) {
          setState(() {
            isreferral = true;
          });
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  checkForUserDetails() async {
    final url = Uri.parse(
        'https://bhit-c7c8a-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      final List<User> users = [];
      responseData.forEach((key, value) {
        users.add(
          User.fromMap(value),
        );
      });
      setState(() {
        user = users.firstWhere((element) =>
            element.userID == Provider.of<Auth>(context, listen: false).userID);
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void initState() {
    checkForReferral();
    checkForUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Refferal section',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Hey ${user?.emailID}',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            isreferral
                ? const SizedBox(
                    height: 50,
                  )
                : const SizedBox(
                    height: 0,
                  ),
            isreferral
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'You were referred to by \n ${referralUser?.emailID} enjoy the features',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                : Text(''),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Why dont you introduce us to your friends \n lets help your friend \n get exclusive benefits on using bhive',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReferralCode(
                        referralCode: usersreferralCode,
                        userModel: user,
                      ),
                    ),
                  );
                }, // login Functionality
                child: const Text(
                  'Refer a Friend',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Welcome(),
                    ),
                  );
                }, // login Functionality
                child: const Text(
                  'Enter referral code',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
