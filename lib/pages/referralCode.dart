import 'package:bhitest/core/models/user.dart';
import 'package:flutter/material.dart';

class ReferralCode extends StatefulWidget {
  final String? referralCode;
  final User? userModel;
  ReferralCode({Key? key, this.referralCode, this.userModel}) : super(key: key);

  @override
  State<ReferralCode> createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  @override
  Widget build(BuildContext context) {
    print(widget.userModel?.userID);
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
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Hey ${widget.userModel?.emailID}',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Send this Code to your friend \n to become a referral and \n enjoy exclusive benefits from bhive',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
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
              onPressed: () {}, // login Functionality
              child: Text(
                '${widget.userModel?.referralCode}',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
