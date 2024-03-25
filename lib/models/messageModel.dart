import 'dart:convert';

class Msg {
  Msg({
    this.text,
    this.createdBy,
    this.createdAt,
  });
  String? text;
  String? createdBy;
  DateTime? createdAt;

  factory Msg.fromString(String str) => Msg.fromJson(jsonDecode(str));

  Msg.fromJson(Map<String, dynamic> json) {
    try {
      text = json['text'] ?? '';
      createdBy = json['createdBy'] ?? '';
      createdAt = json['createdAt']?.toDate();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        'text': text ?? '',
        'createdBy': createdBy ?? '',
        'createdAt': createdAt.toString(),
      };

  @override
  String toString() => jsonEncode(toJson());
}
