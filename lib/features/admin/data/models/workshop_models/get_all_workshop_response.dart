
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';

GetAllWorkshopsResponse getAllWorkshopsResponseFromJson( str) => GetAllWorkshopsResponse.fromJson(str);


class GetAllWorkshopsResponse {
  final List<WorkshopModel>? data;

  GetAllWorkshopsResponse({
    this.data,
  });

  factory GetAllWorkshopsResponse.fromJson(Map<String, dynamic> json) => GetAllWorkshopsResponse(
    data: json["data"] == null ? [] : List<WorkshopModel>.from(json["data"]!.map((x) => WorkshopModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };

  GetAllWorkshopsResponse copyWith({
    List<WorkshopModel>? data,
  }) {
    return GetAllWorkshopsResponse(
      data: data ?? this.data,
    );
  }
}

