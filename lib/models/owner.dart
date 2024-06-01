import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Owner {
  int? id;
  dynamic userCode;
  String? mobileCode;
  String? residentCountryName;
  String? nationalityCountryName;
  String? cityName;
  String? mobile;
  String? name;
  String? userName;
  String? email;
  RxString? profileImage;
  RxString? tempProfileImage;
  int? gender;
  int? available;
  int? active;
  int? premium;
  DateTime? packageRenewDate;
  dynamic susbendedTillDate;
  int? veil;
  int? special;
  int? residentCountryId;
  int? nationalityCountryId;
  int? packageId;
  int? cityId;
  int? age;
  int? weight;
  int? height;
  int? mariageStatues;
  int? kids;
  int? mariageKind;
  int? skinColor;
  int? smoking;
  int? religiosity;
  int? prayer;
  int? education;
  int? financial;
  int? workField;
  int? packageLevel;
  int? income;
  int? helath;
  String? job;
  String? aboutMe;
  String? aboutOther;
  DateTime? joinDate;
  DateTime? lastAccess;
  String? detectedCountry;
  String? deviceToken;
  int? receiveNotification;
  String? contactsNationality;
  String? contactResident;
  int? contactAgesFrom;
  int? contactAgesTo;
  dynamic photoUsers;

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userName = json['userName'] ?? "";
    name = json['name'] ?? "";
    mobile = json['mobile'] ?? "";
    mobileCode = json['mobileCode'] ?? "";
    userCode = json["userCode"];
    email = json['email'] ?? "";
    available = json['available'] ?? 0;
    packageLevel = json['packageLevel'] ?? 0;
    profileImage = (json['profileImage'] ?? "").toString().obs;
    tempProfileImage = (json['tempProfileImage'] ?? "").toString().obs;
    photoUsers = json['photoUsers'];
    packageId = json['packageId'] ?? 0;
    receiveNotification = json['receiveNotification'] ?? 0;
    contactsNationality = json['contactsNationality'] ?? "0";
    contactAgesTo = json['contactAgesTo'] ?? 0;
    contactResident = json['contactResident'] ?? "0";
    contactAgesFrom = json['contactAgesFrom'] ?? 0;
    special = json['special'] ?? 0;
    active = json['active'] ?? 0;
    gender = json['gender'] ?? 0;
    lastAccess =
        json['lastAccess'] != null ? DateTime.parse(json['lastAccess']) : null;
    packageRenewDate = json['packageRenewDate'] != null
        ? DateTime.parse(json['packageRenewDate'])
        : null;
    susbendedTillDate = json['susbendedTillDate'] != null
        ? DateTime.parse(json['susbendedTillDate'])
        : null;
    premium = json['packageId'] ?? 0;
    residentCountryId = json['residentCountryId'] ?? 0;
    residentCountryName = json['residentCountryName'] ?? "";
    nationalityCountryId = json['nationalityCountryId'] ?? 0;
    nationalityCountryName = json['nationalityCountryName'] ?? "";
    cityId = json['cityId'] ?? 0;
    veil = json['veil'];
    cityName = json['cityName'] ?? "";
    mariageStatues = json['mariageStatues'] ?? 0;
    mariageKind = json['mariageKind'] ?? 0;
    age = json['age'] ?? 0;
    kids = json['kids'] ?? 0;
    weight = json['weight'] ?? 0;
    height = json['height'] ?? 0;
    skinColor = json['skinColor'] ?? 0;
    smoking = json['smoking'] ?? 0;
    religiosity = json['religiosity'] ?? 0;
    prayer = json['prayer'] ?? 0;
    education = json['education'] ?? 0;
    financial = json['financial'] ?? 0;
    workField = json['workField'] ?? 0;
    job = json['job'] ?? "0";
    income = json['income'] ?? 0;
    helath = json['helath'] ?? 0;
    aboutMe = json['aboutMe'] ?? "";
    aboutOther = json['aboutOther'] ?? "";
    joinDate = json['creationDate'] != null
        ? DateTime.parse(json['creationDate'])
        : null;
    detectedCountry = json['detectedCountry'] ?? "";
    deviceToken = json['deviceToken'] ?? "";
  }

  Owner({
    this.id,
    this.userCode,
    this.mobileCode,
    this.mobile,
    this.name,
    this.userName,
    this.residentCountryName,
    this.packageLevel,
    this.nationalityCountryName,
    this.cityName,
    this.email,
    this.profileImage,
    this.gender,
    this.available,
    this.packageId,
    this.active,
    this.premium,
    this.packageRenewDate,
    this.susbendedTillDate,
    this.special,
    this.residentCountryId,
    this.nationalityCountryId,
    this.tempProfileImage,
    this.cityId,
    this.age,
    this.veil,
    this.weight,
    this.height,
    this.mariageStatues,
    this.kids,
    this.mariageKind,
    this.skinColor,
    this.smoking,
    this.religiosity,
    this.prayer,
    this.education,
    this.financial,
    this.workField,
    this.income,
    this.helath,
    this.job,
    this.aboutMe,
    this.aboutOther,
    this.joinDate,
    this.lastAccess,
    this.detectedCountry,
    this.deviceToken,
    this.receiveNotification,
    this.contactsNationality,
    this.contactResident,
    this.contactAgesFrom,
    this.contactAgesTo,
    this.photoUsers,
  });
}
