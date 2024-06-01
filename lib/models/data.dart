class Response {
  int? rowsCount;
  List<Item>? data;

  Response({
    //this.page,
    this.rowsCount,
    this.data,
  });

  Response.fromJson(Map<String, dynamic> json) {
    //page = json['page'];
    rowsCount = json['rowsCount'];
    if (json['data'] != null) {
      data = <Item>[];
      json['data'].forEach((v) {
        (data ?? []).add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //  data['page'] = this.page;
    data['rowsCount'] = rowsCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  Map<String, dynamic>? item;

  Item({
    this.item,
  });

  Item.fromJson(Map<String, dynamic> json) {
    item = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> item = this.item ?? {};
    return item;
  }

  returnKey(key) {
    return item![key];
  }
}
