class SignupModel {
  String fullName;
  String username;
  String email;
  String password;

  String dateOfBirth;
  String gender;
  String interestedIn;
  String country;
  String city;

  SignupModel({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.interestedIn = 'Women',
    this.country = '',
    this.city = '',
  });
}