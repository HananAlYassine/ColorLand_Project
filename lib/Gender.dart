class Gender {
  String gender;

  Gender(this.gender);

  @override
  String toString() {
    // How it appears in the dropdown
    return '$gender';
  }
}

List<Gender> genders = [
  Gender("👦 Boy"),
  Gender("👧 Girl"),
];



