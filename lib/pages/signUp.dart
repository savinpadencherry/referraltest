import 'dart:convert';

import 'package:bhitest/core/provider/auth.dart';
import 'package:bhitest/pages/login.dart';
import 'package:bhitest/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../core/models/http_exp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _globalKeySignUp = GlobalKey<FormState>();
  TextEditingController _emailControllerSignUp = TextEditingController();
  TextEditingController _passwordControllerSignUp = TextEditingController();
  final Map<String?, String?> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  String? authType = '';

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An error occured'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> createDetailsinFireStore() async {
    final url = Uri.parse(
        'https://bhit-c7c8a-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'userId': Provider.of<Auth>(context, listen: false).userID,
            'emailID': _emailControllerSignUp.text.trim(),
            'referralCode': _authData['email']!.substring(0, 3) +
                Provider.of<Auth>(context, listen: false)
                    .userID!
                    .substring(0, 3),
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  submit() async {
    if (!_globalKeySignUp.currentState!.validate()) {
      // Invalid
      return;
    }
    _globalKeySignUp.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).SignUp(
          email: _emailControllerSignUp.text.trim(),
          password: _passwordControllerSignUp.text.trim());
      createDetailsinFireStore();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created"),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome(),
        ),
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        //change keywords according to databasse
        errorMessage = 'This Email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        //change keywords according to databasse
        errorMessage = 'Please try again with a valid Email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        //change keywords according to databasse
        errorMessage = 'Weak password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email Not Found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Wrong Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not Authenticate you.Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: Text(
                  'Create a new Account',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _globalKeySignUp,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      maxLines: 1,
                      controller: _emailControllerSignUp,
                      onSaved: (value) {
                        _authData['email'] = _emailControllerSignUp.text.trim();
                      },
                      validator: (input) => !input!.contains("@")
                          ? "Email Id should be of valid type"
                          : null,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: const Color(0xffE8EDF6),
                        hintText: "Email Address",
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      maxLines: 1,
                      controller: _passwordControllerSignUp,
                      onSaved: (value) {
                        _authData['password'] =
                            _passwordControllerSignUp.text.trim();
                      },
                      validator: (input) =>
                          input!.length < 3 ? "Incorrect Password" : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: const Color(0xffE8EDF6),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      maxLines: 1,
                      onSaved: (value) {
                        _authData['password'] =
                            _passwordControllerSignUp.text.trim();
                      },
                      validator: (value) {
                        if (value != _passwordControllerSignUp.text) {
                          return "Passwords Dont match";
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: const Color(0xffE8EDF6),
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () {
                        submit();
                      }, // login Functionality
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () => Login(),
              child: RichText(
                text: TextSpan(
                  text: 'Have an account already?',
                  style: GoogleFonts.cambay(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: GoogleFonts.cambay(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/signUp.png',
              fit: BoxFit.contain,
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
