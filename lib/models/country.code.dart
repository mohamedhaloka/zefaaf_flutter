class CountryData {
  int? id, timezone;
  String? shortcut, nameEn, nameAr, phoneCode, currencyEn, currencyAr;
  CountryData(
      {this.id,
      this.shortcut,
      this.nameEn,
      this.nameAr,
      this.phoneCode,
      this.timezone,
      this.currencyEn,
      this.currencyAr});

  CountryData.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    shortcut = map['shortcut'];
    nameEn = map['nameEn'];
    nameAr = map['nameAr'];
    phoneCode = map['phoneCode'];
    timezone = map['timezone'];
    currencyEn = map['currencyEn'];
    currencyAr = map['currencyAr'];
  }
}
