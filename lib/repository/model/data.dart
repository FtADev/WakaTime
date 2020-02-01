import 'package:waka/repository/model/category.dart';
import 'package:waka/repository/model/dependency.dart';
import 'package:waka/repository/model/editors.dart';
import 'package:waka/repository/model/grand_total.dart';
import 'package:waka/repository/model/language.dart';
import 'package:waka/repository/model/machine.dart';
import 'package:waka/repository/model/os.dart';
import 'package:waka/repository/model/projects.dart';
import 'package:waka/repository/model/range.dart';

class Data {
  List<Categories> categories;
  List<Dependencies> dependencies;
  List<Editors> editors;
  GrandTotal grandTotal;
  List<Languages> languages;
  List<Machines> machines;
  List<OperatingSystems> operatingSystems;
  List<Projects> projects;
  Range range;

  Data(
      {this.categories,
      this.dependencies,
      this.editors,
      this.grandTotal,
      this.languages,
      this.machines,
      this.operatingSystems,
      this.projects,
      this.range});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['dependencies'] != null) {
      dependencies = new List<Dependencies>();
      json['dependencies'].forEach((v) {
        dependencies.add(new Dependencies.fromJson(v));
      });
    }
    if (json['editors'] != null) {
      editors = new List<Editors>();
      json['editors'].forEach((v) {
        editors.add(new Editors.fromJson(v));
      });
    }
    grandTotal = json['grand_total'] != null
        ? new GrandTotal.fromJson(json['grand_total'])
        : null;
    if (json['languages'] != null) {
      languages = new List<Languages>();
      json['languages'].forEach((v) {
        languages.add(new Languages.fromJson(v));
      });
    }
    if (json['machines'] != null) {
      machines = new List<Machines>();
      json['machines'].forEach((v) {
        machines.add(new Machines.fromJson(v));
      });
    }
    if (json['operating_systems'] != null) {
      operatingSystems = new List<OperatingSystems>();
      json['operating_systems'].forEach((v) {
        operatingSystems.add(new OperatingSystems.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      projects = new List<Projects>();
      json['projects'].forEach((v) {
        projects.add(new Projects.fromJson(v));
      });
    }
    range = json['range'] != null ? new Range.fromJson(json['range']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.dependencies != null) {
      data['dependencies'] = this.dependencies.map((v) => v.toJson()).toList();
    }
    if (this.editors != null) {
      data['editors'] = this.editors.map((v) => v.toJson()).toList();
    }
    if (this.grandTotal != null) {
      data['grand_total'] = this.grandTotal.toJson();
    }
    if (this.languages != null) {
      data['languages'] = this.languages.map((v) => v.toJson()).toList();
    }
    if (this.machines != null) {
      data['machines'] = this.machines.map((v) => v.toJson()).toList();
    }
    if (this.operatingSystems != null) {
      data['operating_systems'] =
          this.operatingSystems.map((v) => v.toJson()).toList();
    }
    if (this.projects != null) {
      data['projects'] = this.projects.map((v) => v.toJson()).toList();
    }
    if (this.range != null) {
      data['range'] = this.range.toJson();
    }
    return data;
  }
}
