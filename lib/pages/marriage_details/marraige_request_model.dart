class MarriageRequestData {
  final int? id;
  final int? userId;
  final DateTime? messageDateTime;
  final int? reasonId;
  final String? title;
  final String? message;
  final int? readed;
  final int? owner;
  final dynamic image;
  final dynamic adminImage;
  final int? otherId;
  final dynamic reply;

  MarriageRequestData({
    this.id,
    this.userId,
    this.messageDateTime,
    this.reasonId,
    this.title,
    this.message,
    this.readed,
    this.owner,
    this.image,
    this.adminImage,
    this.otherId,
    this.reply,
  });

  factory MarriageRequestData.fromJson(Map<String, dynamic> json) =>
      MarriageRequestData(
        id: json["id"],
        userId: json["userId"],
        messageDateTime: DateTime.tryParse(json["messageDateTime"]),
        reasonId: json["reasonId"],
        title: json["title"],
        message: json["message"],
        readed: json["readed"],
        owner: json["owner"],
        image: json["image"],
        adminImage: json["adminImage"],
        otherId: json["otherId"],
        reply: json["reply"],
      );
}
