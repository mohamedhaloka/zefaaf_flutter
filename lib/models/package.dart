class PackageModel {
  int? id, usdValue, validFor;
  String? image, title, iapId;

  PackageModel(
      {this.id,
      this.image,
      this.usdValue,
      this.title,
      this.validFor,
      this.iapId});
  factory PackageModel.fromJson(Map json) => PackageModel(
        id: json['id'] ?? 0,
        image: json['image'] ?? "",
        usdValue: json['usdValue'] ?? 0,
        validFor: json['validFor'] ?? 0,
        title: json['title'] ?? '',
        iapId: json['iapId'] ?? '',
      );
}
