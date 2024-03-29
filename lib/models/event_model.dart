class EventsModel {
  String? id;
  String? date;
  String? title;
  num? timestamp;
  String? description;
  String? imgUrl;
  String? location;
  String? time;
  List<String>? views;
  List<String>? registeredUsers;

  EventsModel(
      {
        this.id,
        this.date,
        this.views,
        this.title,
        this.description,
        this.imgUrl,
        this.timestamp,
        this.location,
        this.time,
        this.registeredUsers,
      });

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    if (json['views'] != null) {
      views = <String>[];
      json['views'].forEach((v) {
        views!.add(v);
      });
    }
    if (json['registeredUsers'] != null) {
      registeredUsers = <String>[];
      json['registeredUsers'].forEach((v) {
        registeredUsers!.add(v);
      });
    }
    title = json['title'];
    timestamp = json['timestamp'];
    description = json['description'];
    imgUrl = json['imgUrl'];
    location = json['location'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['title'] = this.title;
    data['timestamp'] = this.timestamp;
    data['description'] = this.description;
    data['imgUrl'] = this.imgUrl;
    data['location'] = this.location;
    data['time'] = this.time;
    if (this.views != null) {
      data['views'] = this.views!.map((v) => v).toList();
    }
    if (this.registeredUsers != null) {
      data['registeredUsers'] = this.registeredUsers!.map((v) => v).toList();
    }
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return date!;
      case 2:
        return time!;
      case 3:
        return location!.toString();
      case 4:
        return description!;
    }
    return '';
  }
}
