import 'package:bhitest/pages/mainHome.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  TextEditingController _referralCodeController = TextEditingController();
  String? referralCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: _referralCodeController,
                  onSaved: (value) {
                    referralCode = _referralCodeController.text.trim();
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: const Color(0xffE8EDF6),
                    hintText: "Referral Code",
                    hintStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text('Dont Have a Referral Code?No problem proceed')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainHome(
              referralCode: _referralCodeController.text.trim(),
            ),
          ),
        ),
        label: const Icon(Icons.forward),
      ),
    );
  }
}
