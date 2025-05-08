class NoteModel {
  final String? id;
  late final String title;
  late final String subtitle;
  late final int color;
  final String date;

  NoteModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.date,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id'].toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: _parseColor(json['color']),
      date: json['date'] ?? DateTime.now().toString(),
    );
  }


static int _parseColor(dynamic color) {
  if (color is int) return color;
  if (color is String) {
    try {
      final match = RegExp(r'0x[0-9A-Fa-f]{8}').firstMatch(color);
      if (match != null) {
        return int.parse(match.group(0)!);
      }
    } catch (e) {
      print('⚠️ Error parsing color: $e');
    }
  }
  return 0xFFA8D5E2; 
}



  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'subtitle': subtitle,
      'color': color,
      'date': date,
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    int? color,
    String? date,
  }) {
    return NoteModel(
      id: id ,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      color: color ?? this.color,
      date: date ?? this.date,
    );
  }
}