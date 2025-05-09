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
    color = _parseColor(json['color']);
    date = json['date'];
    iV = json['__v'];
  }
  int _parseColor(dynamic colorValue) {
  if (colorValue == null) return 0xFFFFFFFF;

  if (colorValue is int) {
    return colorValue;
  }

  final colorString = colorValue.toString();

  if (colorString.startsWith('Color(')) {
    final hexString = colorString.replaceAll('Color(', '').replaceAll(')', '');
    return int.tryParse(hexString) ?? 0xFFFFFFFF;
  }

  return int.tryParse(colorString) ?? 0xFFFFFFFF;
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