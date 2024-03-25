import 'package:bcrud/controllers/firestorePaths.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appointmentModel.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference<Appuser> _usersRef =
      _firestore.collection(FirestorePaths.users).withConverter<Appuser>(
            fromFirestore: (snapshot, _) => Appuser.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );
  static final CollectionReference<AppointmentModel> _appointmentsRef =
      _firestore.collection(FirestorePaths.appointments).withConverter(
          fromFirestore: (snapshot, _) =>
              AppointmentModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (user, _) => user.toJson());

  static Stream<DocumentSnapshot<Appuser>> streamUserDocument(String uid) =>
      _usersRef
          .withConverter<Appuser>(
              fromFirestore: (snapshot, _) =>
                  Appuser.fromJson(snapshot.data()!),
              toFirestore: (chatModel, _) => chatModel.toJson())
          .doc(uid)
          .snapshots(includeMetadataChanges: true);

  Appuser? handleValue(DocumentSnapshot<Appuser> value) {
    if (value.exists) {
      return value.data();
    } else {
      return null;
    }
  }

  static Future<Appuser?> getUserDetails(String uid) async {
    try {
      return await _usersRef
          .doc(uid)
          .get()
          .then((value) => value.exists ? value.data() : null);

      //var usr = await _firestore
      //    .collection(FirestorePaths.users)
      //    .doc(uid)
      //    .get()
      //    .then((value) {
      //  var tmp = value.data();
      //  return value.exists ? value.data() : null;
      //});
      //print(jsonEncode(usr));
      //_user.data();
      //return Appuser.fromJson(usr ?? {});
      //return Appuser();
      //return usr;
    } catch (e) {
      return null;
    }
  }

  static createUser(Appuser newUser) async {
    try {
      await _usersRef.doc(newUser.uid).set(newUser);
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }
  //int sum( int a, int b)

  static updateUser(
      String uid, name, address, bloodGroup, phonenumber, int age) async {
    try {
      await _usersRef.doc(uid).update({
        'name': name,
        'address': address,
        'bloodGroup': bloodGroup,
        'phonenumber': phonenumber,
        'age': age
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static updatedocUser(
      {String? uid,
      String? name,
      String? address,
      String? specialization,
      String? about,
      String? phonenumber,
      int? age,
      int? workExperience}) async {
    try {
      await _usersRef.doc(uid).update({
        'name': name,
        'address': address,
        'specialization': specialization,
        'about': about,
        'phonenumber': phonenumber,
        'age': age,
        'workExperience': workExperience
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<Appuser?>> getAllApprovedDoctors(String patientId) async {
    //if (patientIds.isEmpty) return [];
    try {
      return await _usersRef
          .where('type', isEqualTo: UserTypes.doctor)
          .where('patients', arrayContains: patientId)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => e.exists ? e.data() : null).toList());
      //return [];
    } catch (e) {
      return [];
    }
  }

  //static Future<List<Appuser?>> getAllApprovedFamilymembersTODO(
  //    String patientId) async {
  //  //if (patientIds.isEmpty) return [];
  //  try {
  //    return await _usersRef
  //        .where('type', isEqualTo: UserTypes.patient)
  //        .where('familyMembers', arrayContains: patientId)
  //        .get()
  //        .then((snapshot) =>
  //            snapshot.docs.map((e) => e.exists ? e.data() : null).toList());
  //    //return [];
  //  } catch (e) {
  //    return [];
  //  }
  //}

  static Future<List<Appuser?>?> getAllDoctors() async {
    try {
      return await _usersRef
          .where('type', isEqualTo: UserTypes.doctor)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => e.exists ? e.data() : null).toList());

      //List<Appuser> _doctors = [];
      //for (var snapshot in _snapshots.docs) {
      //  _doctors.add(Appuser.fromJson(snapshot.data() as Map<String, dynamic>));
      //}
      //return _doctors;
      //return [];
    } catch (e) {
      return null;
    }
  }

  static Future<List<Appuser?>?> getAdAllPatients() async {
    try {
      return await _usersRef
          .where('type', isEqualTo: UserTypes.patient)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => e.exists ? e.data() : null).toList());

      //List<Appuser> _doctors = [];
      //for (var snapshot in _snapshots.docs) {
      //  _doctors.add(Appuser.fromJson(snapshot.data() as Map<String, dynamic>));
      //}
      //return _doctors;
      //return [];
    } catch (e) {
      return null;
    }
  }

  // doctor inte approval request cheiyunnu..
  static Future<String> requestApproval(
      String docuid, List<String> patients) async {
    try {
      await _usersRef
          .doc(docuid)
          .update({'pendingApprovals': FieldValue.arrayUnion(patients)});
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> acceptApprovals(
      String docuid, List<String> requests) async {
    if (requests.isEmpty) return 'ok';
    try {
      await _usersRef.doc(docuid).update({
        'patients': FieldValue.arrayUnion(requests),
        'pendingApprovals': FieldValue.arrayRemove(requests)
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> addFamilyMembers(
      String docuid, List<String> familyMembers) async {
    try {
      await _usersRef
          .doc(docuid)
          .update({'familyMembers': FieldValue.arrayUnion(familyMembers)});
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<Appuser?>?> getAllUsers(List<String> uids) async {
    try {
      return await _usersRef
          .where('uid', whereIn: uids)
          .get()
          .then((v) => v.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }

  static Future<List<Appuser?>?> getAllPatients(List<String> uids) async {
    try {
      return await _usersRef
          .where('uid', whereIn: uids)
          .get()
          .then((v) => v.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }

  static getPatientDetails(List<String> patientIds) async {
    if (patientIds.isEmpty) return [];
    try {
      return await _usersRef.where('uid', whereIn: patientIds).get().then(
          (value) =>
              value.docs.map((e) => e.exists ? e.data() : null).toList());
      //.then((value) => value.exists ? value.data() : null);
      //return 'ok';
    } catch (e) {
      return [];
    }
  }

  static Future<String?> bookAppointment(
      AppointmentModel appointmentModel) async {
    try {
      await _appointmentsRef.add(appointmentModel);
      return 'ok';
    } catch (e) {
      return null;
    }
  }

  static Future<String> cancelAppointment(String appointmentId) async {
    try {
      await _appointmentsRef
          .doc(appointmentId)
          .update({'status': AppointmentStatus.cancelled});
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<AppointmentModel?>?> getAllMyAppointments(
    String idField,
    String docid,
  ) async {
    try {
      return await _appointmentsRef
          .where(idField, isEqualTo: docid)
          .get()
          .then((v) => v.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }

  static Future<String> acceptAppointment(String appointmentId) async {
    try {
      await _appointmentsRef.doc(appointmentId).update({
        'status': AppointmentStatus.approved,
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> declineAppointment(String appointmentId) async {
    try {
      await _appointmentsRef.doc(appointmentId).update({
        'status': AppointmentStatus.declined,
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> rescheduleAppointment(
      String appointmentId, DateTime dateTime) async {
    try {
      await _appointmentsRef.doc(appointmentId).update({
        'status': AppointmentStatus.rescheduled,
        'dateTime': dateTime,
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> acceptdoctor(String docstatusId) async {
    try {
      // run cheithu nokavo ok debiug  ok exit pattunilla

      print(docstatusId);
      await _usersRef.doc(docstatusId).update({
        'docstatus': Docstatus.verified,
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> rejectdoctor(String docstatusId) async {
    try {
      await _usersRef.doc(docstatusId).update({
        'docstatus': Docstatus.rejected,
      });
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  static Future<List<Appuser?>?> getAcceptedDoctors() async {
    try {
      return await _usersRef
          .where('docstatus', isEqualTo: Docstatus.verified)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }

  static Future<List<Appuser?>?> getRejectedDoctors() async {
    try {
      return await _usersRef
          .where('docstatus', isEqualTo: Docstatus.rejected)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }
}
