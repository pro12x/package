class Note {
  int? id;
  String title;
  String body;
  String date;

  Note({
    this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  // I convert a note into Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'body': body,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // I create a note from a Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      date: map['date'],
    );
  }
}