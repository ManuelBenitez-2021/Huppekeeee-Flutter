class LabelModel {
  String id;
  String regdate;
  String uid;
  String barcode;
  String content;

  LabelModel({this.id, this.regdate, this.uid, this.barcode, this.content});

  toJson() {
    return {
      "id": id,
      "regdate": regdate,
      "uid": uid,
      "barcode": barcode,
      "content": content,
    };
  }

}