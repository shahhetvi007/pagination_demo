// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  int status;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.notficationlist,
    required this.count,
  });

  List<Notficationlist> notficationlist;
  int count;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notficationlist: List<Notficationlist>.from(
            json["notficationlist"].map((x) => Notficationlist.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "notficationlist":
            List<dynamic>.from(notficationlist.map((x) => x.toJson())),
        "count": count,
      };
}

class Notficationlist {
  Notficationlist({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
  });

  String id;
  String title;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  String isRead;

  factory Notficationlist.fromJson(Map<String, dynamic> json) =>
      Notficationlist(
        id: json["_id"],
        title: json["title"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isRead": isRead,
      };
}

enum Message {
  HOW_ARE_YOU_FEELING_THIS_EVENING,
  HOW_ARE_YOU_FEELING_THIS_AFTERNOON,
  HOW_ARE_YOU_FEELING_THIS_MORNING
}

final messageValues = EnumValues({
  "How are you feeling this afternoon?":
      Message.HOW_ARE_YOU_FEELING_THIS_AFTERNOON,
  "How are you feeling this evening?": Message.HOW_ARE_YOU_FEELING_THIS_EVENING,
  "How are you feeling this morning? ": Message.HOW_ARE_YOU_FEELING_THIS_MORNING
});

enum Title { GOOD_EVENING, GOOD_AFTERNOON, GOOD_MORNING }

final titleValues = EnumValues({
  "Good Afternoon": Title.GOOD_AFTERNOON,
  "Good Evening": Title.GOOD_EVENING,
  "Good Morning": Title.GOOD_MORNING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
