class StateModel {
  String? state;
  List<String>? districts;

  StateModel({this.state, this.districts});

  fromJson(Map<String, dynamic> json) {
    state = json['state'];
    districts = json['districts'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['districts'] = districts;
    return data;
  }
}