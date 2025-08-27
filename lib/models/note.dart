class Note {
  /**
   * operations:
   * 1) Constructor : fromMap => Convert object to map
   * 2) Function : toMap => Convert map to object
   */
  late String id;
  late String title;
  late String info;

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    info = map['info'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['info'] = info;
    return map;
  }
}
