class NotificationModel {
  int? id;
  String? date;
  String? image;
  String? title;
  String? userName;
  int? notiType;
  int? isPremium;
  int? isLive;
  int? userId;
  String? subTitle;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user['id'] = id;
    user['profileImage'] = image;
    user['publishDateTime'] = date;
    user['title'] = title;
    user['notiType'] = notiType;
    user['userName'] = userName;
    user['userId'] = userId;
    user['message'] = subTitle;
    return user;
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['profileImage'];
    title = json['title'];
    userName = json['userName'];
    userId = json['userId'];
    date = json['publishDateTime'];
    notiType = json['notiType'];
    subTitle = json['message'];
  }

  NotificationModel(
      {this.id,
      this.date,
      this.userId,
      this.image,
      this.notiType,
      this.title,
      this.isLive,
      this.userName,
      this.isPremium,
      this.subTitle});
}
