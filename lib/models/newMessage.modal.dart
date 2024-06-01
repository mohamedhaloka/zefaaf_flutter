class NewMessagesModal {
  int? id, reasonId, userId, owner, readed;
  String? messageDateTime, message, title, reply, image, adminImage;

  NewMessagesModal(
      {this.id,
      this.userId,
      this.messageDateTime,
      this.readed,
      this.reasonId,
      this.message,
      this.adminImage,
      this.title,
      this.image});

  NewMessagesModal.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    messageDateTime = map['messageDateTime'];
    reasonId = map['reasonId'];
    owner = map['owner'];
    reply = map['reply'];
    readed = map['readed'];
    adminImage = map['adminImage'] ?? '';
    title = map['title'];
    message = map['message'];
    image = map['image'] ?? '';
  }

  String get messageType {
    switch (reasonId) {
      case 0:
        return 'إستفسار';
      case 1:
        return 'شكوى';
      case 2:
        return 'إقتراح';
      case 4:
        return 'رسالة من زفاف';
      default:
        return '';
    }
  }
}
