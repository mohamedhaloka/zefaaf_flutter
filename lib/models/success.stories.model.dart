class SuccessStoriesModel {
  SuccessStoriesModel(
      {required this.storyDate,
      required this.story,
      required this.husName,
      required this.wifName,
      required this.id});

  String storyDate, story, husName, wifName;
  int id;

  factory SuccessStoriesModel.fromJson(Map<String, dynamic> json) =>
      SuccessStoriesModel(
        storyDate: json["storyDate"] ?? "",
        story: json["story"] ?? "",
        husName: json["husName"] ?? "",
        wifName: json["wifName"] ?? "",
        id: json["id"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "storyDate": storyDate,
        "story": story,
        "husName": husName,
        "wifName": wifName,
        "id": id,
      };
}
