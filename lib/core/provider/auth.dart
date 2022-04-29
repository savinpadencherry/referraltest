import 'package:bhitest/core/models/http_exp.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _email;
  DateTime? _expiryDate;

  bool get isAuth {
    return token != null;
  }

  bool get isAuthenticated {
    return _token != null;
  }

  String? get token1 {
    return token;
  }

  String? get userID {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(
          DateTime.now(),
        ) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(String? email, String? password, String? urlSegment,
      String? authTypeconfirm) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyBlfq6ht99FvEXbhprbVTwsY_8v2fZ0ze0');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _email = email;
      print(_userId);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      //update our user interface by triggering the CONSUMER Method in main.dart
      notifyListeners();
      //Storing the data locally in the device using SharedPreference
      if (authTypeconfirm == 'SignUp') {
        final pref = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': null,
          'userId': _userId,
          'email': _email,
          'expiryDate': _expiryDate!
              .toIso8601String(), //added new token to store in device to auto login
        });
        pref.setString('userData', userData);
      } else {
        final pref = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'email': _email,
          'expiryDate': _expiryDate!
              .toIso8601String(), //added new token to store in device to auto login
        });
        pref.setString('userData', userData);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> SignUp({String? email, String? password}) async {
    return authenticate(email, password, 'signUp', 'SignUp');
  }

  Future<void> login({String? email, String? password}) async {
    return authenticate(email, password, 'signInWithPassword', 'Login');
  }

  Future<void> loginforTailors(
      String? email, String? password, String? authtypeConfirm) async {
    return authenticate(email, password, 'signInWithPassword', 'Tailor');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    var getStringPref = prefs.getString('userData');
    final getUserExtractedData =
        json.decode(getStringPref!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(getUserExtractedData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
      //we dont have a valid token since it has expired
    }
    //This means we got a valid token
    _token = getUserExtractedData['token'].toString();
    _userId = getUserExtractedData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    //  if (_authTimer != null) { _authTimer!.cancel(); _authTimer = null;}

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
}
