class Appuser {
  int? age;
  String? uid;
  String? type;
  String? name;
  String? email;
  String? about;
  String? phoneNumber;
  String? bloodGroup;
  String? address;
  String? docstatus;
  String? specialization;
  int? workExperience;
  List<String>? patients;
  List<String>? familyMembers;
  List<String>? pendingApprovals;
  Appuser({
    this.uid,
    this.age,
    this.type,
    this.name,
    this.email,
    this.about,
    this.phoneNumber,
    this.bloodGroup,
    this.address,
    this.docstatus,
    this.specialization,
    this.workExperience,
    this.patients,
    this.familyMembers,
    this.pendingApprovals,
  });
  Appuser.fromJson(Map<String, dynamic> json) {
    try {
      uid = json['uid'];
      age = json['age'];
      type = json['type'];
      name = json['name'];
      email = json['email'];
      about = json['about'];
      phoneNumber = json['phoneNumber'];
      bloodGroup = json['bloodGroup'];
      address = json['address'];
      docstatus = json['docstatus'];
      specialization = json['specialization'];
      workExperience = json['workExperience'];
      //patients =
      //    List<String>.from(json["patients"]?.map((x) => x)??[]);
      patients = json["patients"] == null
          ? null
          : List<String>.from(json["patients"].map((x) => x));
      familyMembers = json["familyMembers"] == null
          ? null
          : List<String>.from(json["familyMembers"].map((x) => x));
      pendingApprovals = json["pendingApprovals"] == null
          ? null
          : List<String>.from(json["pendingApprovals"].map((x) => x));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Map<String, dynamic> toJson() {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['uid'] = uid;
      data['age'] = age;
      data['type'] = type;
      data['name'] = name;
      data['email'] = email;
      data['about'] = about;
      data['phoneNumber'] = phoneNumber;
      data['bloodGroup'] = bloodGroup;
      data['address'] = address;
      data['docstatus'] = docstatus;
      data['specialization'] = specialization;
      data['patients'] = patients;
      data['familyMembers'] = familyMembers;
      data['workExperience'] = workExperience;
      data['pendingApprovals'] =
          List<String>.from(pendingApprovals?.map((x) => x) ?? []);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
