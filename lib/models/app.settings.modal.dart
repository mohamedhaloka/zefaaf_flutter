class AppSettingsModal {
  String? analyticCode,
      mobile,
      whatsapp,
      facebook,
      instagram,
      websiteLink,
      iphoneLink,
      androidLink,
      registerLicense,
      aboutUs,
      privacy,
      shareText,
      packageDesc,
      mobileVersion,
      mobileVersionDescription,
      registerConditions,
      liveChatCode;
  int? id, version, displayPackages, displayExternalPayments;
  List? fixedData;

  AppSettingsModal(
      {this.id,
      this.analyticCode,
      this.mobile,
      this.whatsapp,
      this.facebook,
      this.instagram,
      this.fixedData,
      this.registerLicense,
      this.websiteLink,
      this.displayPackages,
      this.registerConditions,
      this.iphoneLink,
      this.mobileVersionDescription,
      this.displayExternalPayments,
      this.androidLink,
      this.shareText,
      this.aboutUs,
      this.privacy,
      this.liveChatCode,
      this.packageDesc,
      this.mobileVersion,
      this.version});

  AppSettingsModal.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    analyticCode = map["analyticCode"];
    shareText = map["shareText"];
    mobile = map["mobile"];
    whatsapp = map["Whatsapp"];
    fixedData = map["fixedData"];
    facebook = map["Facebook"];
    mobileVersionDescription = map["mobileVersionDescription"] ?? '';
    instagram = map["Instagram"];
    displayPackages = map["displayPackages"];
    registerLicense = map["registerLicense"] ?? "";
    websiteLink = map["websiteLink"] ?? "";
    registerConditions = map["registerCondetions"] ?? "";
    iphoneLink = map["IphoneLink"] ?? "";
    androidLink = map["AndroidLink"] ?? "";
    aboutUs = map["aboutUs"] ?? "";
    mobileVersion = map["mobileVersion"] ?? "";
    privacy = map["privacy"] ?? "";
    liveChatCode = map["liveChatCode"];
    version = map["version"];
    packageDesc = map["backageDesc"];
    displayExternalPayments = map["displayExternalPayments"] ?? 0;
  }
}
