class TodoDatabase{
  String title, description;
  int id;

  TodoDatabase(this.title, this.description, this.id);

  Map<String, dynamic> todoMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    map['title'] = this.title;
    map['description'] = this.description;
    map['id'] = this.id;
    return map;
  }
}