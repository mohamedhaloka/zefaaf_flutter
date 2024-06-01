class CityModal {
  int? id, special, active;
  String? nameEn, nameAr;
  CityModal({this.id, this.active, this.nameEn, this.nameAr, this.special});

  CityModal.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    active = map['active'];
    nameEn = map['nameEn'];
    nameAr = map['nameAr'];
    special = map['special'];
  }
}
