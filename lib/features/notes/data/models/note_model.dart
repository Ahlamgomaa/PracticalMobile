class NoteModel {
  dynamic id;
  String? title;
  String? subtitle;
  int? color;
  String? date;
  int? iV;

  NoteModel(
      {this.id, this.title, this.subtitle, this.color, this.date, this.iV,});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    subtitle = json['subtitle'];
    color = int.tryParse(json['color']?.toString() ?? '') ?? 0xFFFFFFFF;
    date = json['date'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['color'] = color;
    data['date'] = date;
    data['__v'] = iV;
    return data;
  }
}