class Item{
  String title;
  bool done;

  Item({this.title, this.done});

// tronsformar um json para usar
  Item.fromJson(Map<String, dynamic> json){
    title = json['title'];
    done = json['done'];
  }

// transformar em um json para usar na api
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}