class UserModel {
  String uid;
  String phone;
  String regdate;
  bool isActivie;

  UserModel({this.uid, this.phone, this.regdate, this.isActivie});

  toJson() {
    return {
      "uid": uid,
      "phone": phone,
      "regdate": regdate,
      "isActivie": isActivie,
    };
  }
}