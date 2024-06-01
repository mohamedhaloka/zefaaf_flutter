class User {
  int? id;
  int? otherId;
  String? userName;
  String? userImage;
  int? available;
  int? packageId;
  int? packageLevel;
  int? residentCountryId;
  String? residentCountryName;
  int? nationalityCountryId;
  String? nationalityCountryName;
  int? cityId;
  int? gender;
  String? cityName;
  int? mariageStatues;
  int? mariageKind;
  int? age;
  int? kids;
  int? weight;
  int? height;
  int? skinColor;
  int? smoking;
  dynamic religiosity;
  int? prayer;
  int? veil;
  int? education;
  int? financial;
  int? workField;
  String? job;
  int? income;
  int? helath;
  String? aboutMe;
  String? aboutOther;
  DateTime? creationDate;
  dynamic lastAccess;
  String? detectedCountry;
  dynamic deviceToken;
  String? ignoreList;
  String? interestList;
  String? allowImage;
  String? requestImage;
  String? requestMyImage;
  String? viewMyImage;
  String? lastAccessDate;
  String? lastAccessTime;
  String? allowMobile;
  String? requestMobile;
  String? requestMyMobile;
  String? viewMyMobile;
  String? mobile;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    otherId = json['otherId'] ?? otherId;
    userName = json['userName'] ?? "";
    userImage = json['userImage'] ?? "";
    lastAccessDate = json['lastAccessDate'] ?? "";
    lastAccessTime = json['lastAccessTime'] ?? "";
    requestMobile = json['requestMobile'] ?? "";
    requestMyMobile = json['requestMyMobile'] ?? "";
    viewMyMobile = json['viewMyMobile'] ?? "";
    available = json['available'] ?? 0;
    lastAccess =
        json['lastAccess'] != null ? DateTime.parse(json['lastAccess']) : "";
    packageId = json['packageId'] ?? 0;
    packageLevel = json['packageLevel'] ?? 0;
    residentCountryId = json['residentCountryId'] ?? 0;
    residentCountryName = json['residentCountryName'] ?? "";
    nationalityCountryId = json['nationalityCountryId'] ?? 0;
    nationalityCountryName = json['nationalityCountryName'] ?? "";
    cityId = json['cityId'] ?? 0;
    cityName = json['cityName'] ?? "";
    allowMobile = json['allowMobile'] ?? '0';
    mobile = json['mobile'] ?? "";
    mariageStatues = json['mariageStatues'] ?? 0;
    mariageKind = json['mariageKind'] ?? 0;
    age = json['age'] ?? 0;
    veil = json['veil'] ?? 0;
    kids = json['kids'] ?? 0;
    gender = json['gender'];
    weight = json['weight'] ?? 0;
    height = json['height'] ?? 0;
    skinColor = json['skinColor'] ?? 0;
    smoking = json['smoking'] ?? 0;
    religiosity = json['religiosity'] ?? 0;
    prayer = json['prayer'] ?? 0;
    education = json['education'] ?? 0;
    financial = json['financial'] ?? 0;
    workField = json['workField'] ?? 0;
    job = json['job'] ?? '';
    income = json['income'] ?? 0;

    helath = json['helath'] ?? 0;
    aboutMe = json['aboutMe'] ?? "";
    aboutOther = json['aboutOther'] ?? "";
    creationDate = json['creationDate'] != null
        ? DateTime.parse(json['creationDate'])
        : null;
    detectedCountry = json['detectedCountry'] ?? "";
    deviceToken = json['deviceToken'] ?? "";
    ignoreList = json['ignoreList'] ?? "";
    interestList = json['interestList'] ?? "";
    allowImage = json['allowImage'] ?? "";
    requestImage = json['requestImage'] ?? "";
    requestMyImage = json['requestMyImage'] ?? "";
    viewMyImage = json['viewMyImage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    return user;
  }

  User(
      {this.id,
      this.otherId,
      this.userName,
      this.available,
      this.lastAccess,
      this.packageId,
      this.mobile,
      this.allowMobile,
      this.requestMobile,
      this.requestMyMobile,
      this.viewMyMobile,
      this.residentCountryId,
      this.residentCountryName,
      this.packageLevel,
      this.nationalityCountryId,
      this.nationalityCountryName,
      this.cityId,
      this.cityName,
      this.mariageStatues,
      this.mariageKind,
      this.age,
      this.kids,
      this.weight,
      this.height,
      this.skinColor,
      this.gender,
      this.veil,
      this.smoking,
      this.requestImage,
      this.religiosity,
      this.prayer,
      this.education,
      this.financial,
      this.workField,
      this.lastAccessTime,
      this.lastAccessDate,
      this.job,
      this.income,
      this.helath,
      this.aboutMe,
      this.aboutOther,
      this.creationDate,
      this.viewMyImage,
      this.requestMyImage,
      this.detectedCountry,
      this.deviceToken});
}
