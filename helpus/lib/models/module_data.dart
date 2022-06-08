// Module class that stores condensed data for a module.
class CondensedModule {
  final String moduleCode;
  final String title;
  final String prerequisite;

  CondensedModule(this.moduleCode, this.title, this.prerequisite);

  // Generate condensed module from json data
  static CondensedModule fromJson(Map<String, dynamic> json) {
    return CondensedModule(
      json['moduleCode'],
      json['title'],
      json['prerequisite'] ?? '',
    );
  }

  // Check if the module code or title contains the query text
  bool contains(String query) {
    return moduleCode.toLowerCase().contains(query.toLowerCase()) ||
        title.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String toString() {
    return 'moduleCode: $moduleCode, title: $title, prerequisite: $prerequisite';
  }
}

// Module class that stores grading for a module
class ModuleGrading {
  static final List<String> grades = [
    'A+',
    'A-',
    'A',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'D+',
    'D',
    'F',
  ];
  static final ModuleGrading empty = ModuleGrading('', 0, '', true);

  final String moduleCode;
  final int mc;
  String grade;
  bool isSU;

  ModuleGrading(this.moduleCode, this.mc, this.grade, this.isSU);

  // Obtain grade number from letter grade
  double getGrade() {
    if (grade == grades[0] || grade == grades[1]) {
      return 5;
    } else if (grade == grades[2]) {
      return 4.5;
    } else if (grade == grades[3]) {
      return 4;
    } else if (grade == grades[4]) {
      return 3.5;
    } else if (grade == grades[5]) {
      return 3;
    } else if (grade == grades[6]) {
      return 2.5;
    } else if (grade == grades[7]) {
      return 2;
    } else if (grade == grades[8]) {
      return 1.5;
    } else if (grade == grades[9]) {
      return 1;
    } else if (grade == grades[10]) {
      return 0;
    }
    return -1;
  }

  // Change SU status
  void changeSU() {
    isSU = !isSU;
  }

  // Check if user obtain S or U
  bool checkS() {
    if (grade != grades[-1]) {
      return true;
    }
    return false;
  }

  // Calculate the overall CAP and MC count with given list of moduleGrading
  static List<String> calcModules(List<ModuleGrading> modules) {
    double cap = 0;
    int totalMC = 0;
    for (ModuleGrading module in modules) {
      if (!module.isSU) {
        cap += module.getGrade() * module.mc;
        totalMC += module.mc;
      }
    }
    return [(cap / totalMC).toStringAsFixed(2), totalMC.toString()];
  }

  // Generate module grading from json data
  static ModuleGrading fromJson(Map<String, dynamic> json) {
    return ModuleGrading(
      json['moduleCode'],
      json['mc'],
      json['grade'],
      json['isSU'],
    );
  }

  // Generate json data from module grading
  Map<String, dynamic> toJson() {
    return {
      'moduleCode': moduleCode,
      'mc': mc,
      'grade': grade,
      'isSU': isSU,
    };
  }

  @override
  String toString() {
    return '{moduleCode: $moduleCode, mc: $mc, grade: $grade, isSU: $isSU}';
  }
}
