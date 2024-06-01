class UserChats {
  UserChats(
      {this.image,
      this.id,
      this.readied,
      this.lastSender,
      this.lastMessage,
      this.available,
      this.newMessage,
      this.lastMessageType,
      this.lastMessageTime,
      this.packageLevel,
      this.detectedCountry,
      this.packageId,
      this.lastAccess,
      this.otherName,
      this.otherId});

  String? lastMessage,
      detectedCountry,
      otherName,
      lastMessageTime,
      image,
      lastAccess;
  int? id,
      lastSender,
      readied,
      available,
      otherId,
      lastMessageType,
      newMessage,
      packageLevel,
      packageId;
  UserChats.fromJson(Map<String, dynamic> json) {
    image = json['userImage'];
    id = json['id'];
    lastSender = json['lastSender'];
    readied = json['readed'];
    newMessage = json['new'];
    lastMessageType = json['lastMessageType'];
    detectedCountry = json['detectedCountry'];
    available = json['available'];
    packageId = json['packageId'];
    otherName = json['otherName'] ?? '';
    lastMessageTime = json['lastMessagetime'];
    lastAccess = json['lastAccess'];
    lastMessage = json['lastMessage'] ?? '';
    packageLevel = json['packageLevel'] ?? 0;
    otherId = json['otherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userChats = <String, dynamic>{};
    userChats['otherId'] = otherId;
    userChats['lastMessageTime'] = lastMessageTime;
    userChats['id'] = id;
    userChats['lastMessageType'] = lastMessageType;
    userChats['detectedCountry'] = detectedCountry;
    userChats['lastAccess'] = lastAccess;
    userChats['readed'] = readied;
    userChats['new'] = newMessage;
    userChats['packageLevel'] = packageLevel;
    userChats['available'] = available;
    userChats['packageId'] = packageId;
    userChats['otherName'] = otherName;
    userChats['lastSender'] = lastSender;
    userChats['lastMessage'] = lastMessage;
    userChats['userImage'] = image;

    return userChats;
  }
}
