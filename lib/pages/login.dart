import 'package:bhitest/core/models/http_exp.dart';
import 'package:bhitest/core/provider/auth.dart';
import 'package:bhitest/pages/mainHome.dart';
import 'package:bhitest/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _globalKeyLogin = GlobalKey<FormState>();
  TextEditingController _emailControllerLogin = TextEditingController();
  TextEditingController _passwordControllerLogin = TextEditingController();
  final Map<String?, String?> _authData = {
    'email': '',
    'password': '',
  };
  String? emailId;
  String? passwordID;
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

  submit() async {
    if (!_globalKeyLogin.currentState!.validate()) {
      // Invalid
      return;
    }
    _globalKeyLogin.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
          email: _emailControllerLogin.text.trim(),
          password: _passwordControllerLogin.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainHome(),
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
      print(error);
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
              height: 40,
            ),
            const Center(
              child: Text(
                'Login',
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
                  'Login to your Account',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _globalKeyLogin,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextFormField(
                      maxLines: 1,
                      controller: _emailControllerLogin,
                      onSaved: (value) {
                        _authData['email'] = _emailControllerLogin.text.trim();
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
                      controller: _passwordControllerLogin,
                      onSaved: (value) {
                        _authData['password'] =
                            _passwordControllerLogin.text.trim();
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
                      onPressed: submit, // login Functionality
                      child: const Text(
                        'Login',
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
              onTap: () => SignUp(),
              child: RichText(
                text: TextSpan(
                  text: 'Dont have an Account with us?',
                  style: GoogleFonts.cambay(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
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
            Image.asset('assets/login.png')
          ],
        ),
      ),
    );
  }
}
