class BookRecommendation {
  Similar similar;
  BookRecommendation({this.similar});

  BookRecommendation.fromJson(Map<String, dynamic> json) {
    similar = json['Similar'] != null ? new Similar.fromJson(json['Similar']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.similar != null) {
      data['Similar'] = this.similar.toJson();
    }
    return data;
  }
}

class Similar {
  List<Info> results;

  Similar({this.results});

  Similar.fromJson(Map<String, dynamic> json) {
    if (json['Results'] != null) {
      results = new List<Info>();
      json['Results'].forEach((v) {
        results.add(new Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['Results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String name;
  String type;

  Info({this.name, this.type});

  Info.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Type'] = this.type;
    return data;
  }
}