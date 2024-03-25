class ChatModel {
  String? title;
  List<String>? participants;
  DateTime? updatedAt;
  ChatModel({
    this.title,
    this.participants,
    this.updatedAt,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'] ?? '';
      updatedAt = json['createdAt']?.toDate();
      participants = json["participants"] == null
          ? null
          : List<String>.from(json["participants"].map((x) => x));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Map<String, dynamic> toJson() {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['title'] = title;
      data['updatedAt'] = updatedAt.toString();
      data['participants'] =
          List<String>.from(participants?.map((x) => x) ?? []);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
