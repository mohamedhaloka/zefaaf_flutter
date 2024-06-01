class ReplyMessage {
  int? type, parent;
  dynamic parentMessage;
  ReplyMessage({
    this.type,
    this.parentMessage,
    this.parent,
  });

  ReplyMessage.fromJson(Map<String, dynamic> map) {
    parent = map['parent'];
    parentMessage = map['parentMessage'];
    type = map['type'];
  }
}
