class CondensedModule {
  final String moduleCode;
  final String title;
  final String prerequisite;

  CondensedModule(this.moduleCode, this.title, this.prerequisite);

  static CondensedModule fromJson(Map<String, dynamic> json) {
    return CondensedModule(
      json['moduleCode'],
      json['title'],
      json['prerequisite'] ?? '',
    );
  }

  bool contains(String query) {
    return moduleCode.toLowerCase().contains(query.toLowerCase()) ||
        title.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String toString() {
    return 'moduleCode: $moduleCode, title: $title, prerequisite: $prerequisite';
  }
}
