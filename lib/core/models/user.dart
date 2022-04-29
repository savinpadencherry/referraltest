import 'package:flutter/material.dart';

class User {
  final String? emailID;
  final String? referralCode;
  final String? userID;
  final Key? key;

  User({this.emailID, this.referralCode, this.userID, this.key});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        emailID: map.containsKey('emailID') ? map['emailID'] : null,
        referralCode:
            map.containsKey('referralCode') ? map['referralCode'] : null,
        userID: map.containsKey('userId') ? map['userId'] : null);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (this.emailID != null) {
      map['emailID'] = emailID;
    }
    if (this.userID != null) {
      map['userId'] = userID;
    }
    if (this.referralCode != null) {
      map['referralCode'] = referralCode;
    }
    return map;
  }

  User copyWith({final userID, final referralCode, final emailID}) {
    return User(
      userID: userID ?? this.userID,
      emailID: emailID ?? this.emailID,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  @override
  List<Object?> get props => [this.emailID, this.referralCode, this.userID];
}
