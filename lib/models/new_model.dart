class NewModel {
  final int? id;
  final String? data;

  const NewModel({
    this.id,
    this.data,
  });

  factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(
        id: json['id'],
        data: json['data'],
      );
}
