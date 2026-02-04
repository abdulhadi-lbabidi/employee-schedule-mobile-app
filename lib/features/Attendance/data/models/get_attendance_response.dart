import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';

GetAttendanceResponse getAttendanceResponseFromJson(str) =>
    GetAttendanceResponse.fromJson(str);

class GetAttendanceResponse {
  final List<AttendanceModel>? data;
  final Links? links;
  final Meta? meta;

  GetAttendanceResponse({this.data, this.links, this.meta});

  GetAttendanceResponse copyWith({
    List<AttendanceModel>? data,
    Links? links,
    Meta? meta,
  }) => GetAttendanceResponse(
    data: data ?? this.data,
    links: links ?? this.links,
    meta: meta ?? this.meta,
  );

  factory GetAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      GetAttendanceResponse(
        data:
            json["data"] == null
                ? []
                : List<AttendanceModel>.from(
                  json["data"]!.map((x) => AttendanceModel.fromJson(x)),
                ),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  Links copyWith({String? first, String? last, dynamic prev, dynamic next}) =>
      Links(
        first: first ?? this.first,
        last: last ?? this.last,
        prev: prev ?? this.prev,
        next: next ?? this.next,
      );

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  Meta copyWith({
    int? currentPage,
    int? from,
    int? lastPage,
    List<Link>? links,
    String? path,
    int? perPage,
    int? to,
    int? total,
  }) => Meta(
    currentPage: currentPage ?? this.currentPage,
    from: from ?? this.from,
    lastPage: lastPage ?? this.lastPage,
    links: links ?? this.links,
    path: path ?? this.path,
    perPage: perPage ?? this.perPage,
    to: to ?? this.to,
    total: total ?? this.total,
  );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links:
        json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links":
        links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  Link({this.url, this.label, this.page, this.active});

  Link copyWith({String? url, String? label, int? page, bool? active}) => Link(
    url: url ?? this.url,
    label: label ?? this.label,
    page: page ?? this.page,
    active: active ?? this.active,
  );

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    page: json["page"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}
