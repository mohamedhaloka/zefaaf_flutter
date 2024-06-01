class Post {
  int? id, active, catId;
  String? title, post, featureImage;
  String? postDateTime;

  Post(
      {this.id,
      this.catId,
      this.postDateTime,
      this.title,
      this.post,
      this.active,
      this.featureImage});

  Post.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    catId = map['catId'];
    title = map['title'];
    post = map['post'];
    featureImage = map['featureImage'];
    postDateTime = map['postDateTime'];
    active = map['active'];
  }
}
