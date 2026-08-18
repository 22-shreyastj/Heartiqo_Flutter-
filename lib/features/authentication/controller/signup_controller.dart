import 'package:flutter/material.dart';

import '../model/signup_model.dart';

class SignupController {
  final SignupModel signupModel = SignupModel();

  void nextPage(
    BuildContext context,
    Widget screen,
  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
        ),
      );

  void back(BuildContext context) =>
      Navigator.pop(context);

  void saveAccount({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) {
    signupModel.fullName = fullName;
    signupModel.username = username;
    signupModel.email = email;
    signupModel.password = password;
  }

  void savePersonalDetails({
    required String dateOfBirth,
    required String gender,
    required String interestedIn,
    required String country,
    String state = '',
    required String city,
  }) {
    signupModel.dateOfBirth = dateOfBirth;
    signupModel.gender = gender;
    signupModel.interestedIn = interestedIn;
    signupModel.country = country;
    signupModel.state = state;
    signupModel.city = city;
  }
}