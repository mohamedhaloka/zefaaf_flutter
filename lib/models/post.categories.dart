class PostsCategoriesModal {
  String? title;
  int? id, active;
  PostsCategoriesModal(this.id, this.title, this.active);

  PostsCategoriesModal.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    active = map['active'];
  }
}
