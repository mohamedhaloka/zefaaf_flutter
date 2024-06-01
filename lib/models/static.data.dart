class StaticData {
  String? title;
  int? id, type, gender;
  StaticData({this.title, this.id, this.type, this.gender});

  StaticData.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    gender = map["gender"];
    type = map["type"];
    title = map["title"];
  }
}
