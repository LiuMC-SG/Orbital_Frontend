class Modules {
  final List<CondensedModule> modules;

  Modules(this.modules);

  static Modules fromJson(List<dynamic> json) {
    return Modules(
        json.map((element) => CondensedModule.fromJson(element)).toList());
  }

  Modules filter(String filterText) {
    return Modules(modules
        .where((element) =>
            element.moduleCode.toLowerCase().contains(filterText.toLowerCase()))
        .toList());
  }

  int length() {
    return modules.length;
  }

  CondensedModule get(int index) {
    return modules[index];
  }

  @override
  String toString() {
    return 'Modules{modules: $modules}';
  }
}

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

  @override
  String toString() {
    return 'moduleCode: $moduleCode, title: $title, prerequisite: $prerequisite';
  }
}
