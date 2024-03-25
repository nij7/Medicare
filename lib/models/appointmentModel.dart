class AppointmentModel {
  String? id; // actual document id
  String? uid; // uid of the patient
  String? pname;
  String? dname;
  String? docid;
  String? status;
  String? phNumber;
  DateTime? dateTime;
  AppointmentModel({
    this.id,
    this.uid,
    this.pname,
    this.dname,
    this.docid,
    this.status,
    this.phNumber,
    this.dateTime,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json, String documentId) {
    try {
      id = documentId;
      uid = json['uid'] ?? '';
      pname = json['pname'] ?? '';
      dname = json['dname'] ?? '';
      docid = json['docid'] ?? '';
      status = json['status'] ?? '';
      phNumber = json['phNumber'] ?? '';
      dateTime = json['dateTime']?.toDate();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['uid'] = uid;
      data['pname'] = pname;
      data['dname'] = dname;
      data['docid'] = docid;
      data['status'] = status;
      data['phNumber'] = phNumber;
      data['dateTime'] = dateTime;
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}



/*

const m = {
  'name': 'alan'
}




*/