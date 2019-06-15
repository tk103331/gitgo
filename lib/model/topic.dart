class Topic {
  String name;
  String displayName;
  String description;
  String shortDescription;
  String createBy;

  static Topic fromJson(Map<String, dynamic> input) {
    if (input == null) return null;
    return new Topic()
      ..name = input['name']
      ..displayName = input['display_name']
      ..description = input['description']
      ..shortDescription = input['short_description']
      ..createBy = input["created_by"];
  }
}

