// To parse this JSON data, do
//
//     final agentModel = agentModelFromJson(jsonString);

import 'package:zeffaf/models/package.dart';

class AgentModel {
  AgentModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.whats,
    required this.countryName,
    required this.localValue,
    required this.agentPackages,
  });

  final String name;
  final String email;
  final String mobile;
  final String whats;
  final String? countryName;
  final String? localValue;
  final List<PackageModel> agentPackages;

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        whats: json["whats"] ?? '',
        countryName: json["countryName"] ?? '',
        localValue: json["localValue"] ?? '',
        agentPackages: List.from(
            (json["agentPackages"] ?? []).map((e) => PackageModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "whats": whats,
        "countryName": countryName,
        "localValue": localValue,
      };
}
