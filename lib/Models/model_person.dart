class PersonModel {
  String name = "";
  String street = "";
  String city = "";
  String countryCode = "";
  String countryName = "";
  String postalCode = "";
  String stateOrProvinceCode = "";
  String stateOrProvinceName = "";

  PersonModel({this.name, this.street, this.city
    , this.countryCode, this.countryName, this.postalCode
    , this.stateOrProvinceCode, this.stateOrProvinceName
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return PersonModel();
    }
    String provinceCode = json['stateOrProvinceCode'] as String;
    if (provinceCode == null) provinceCode = '';
    String provinceName = json['stateOrProvinceName'] as String;
    if (provinceName == null) provinceName = '';
    return PersonModel(
      name : json['name'] as String,
      street : json['street'] as String,
      city : json['city'] as String,
      countryCode : json['countryCode'] as String,
      countryName : json['countryName'] as String,
      postalCode : json['postalCode'] as String,
      stateOrProvinceCode : provinceCode,
      stateOrProvinceName : provinceName,
    );
  }
}