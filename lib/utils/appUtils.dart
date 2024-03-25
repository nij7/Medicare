import 'package:bcrud/core/appdata.dart';

class AppUtils {
  static getBloodGroup(String bloodGroup) {
    switch (bloodGroup) {
      case BloodGroups.aPOS:
        return 'A+';
      case BloodGroups.bPOS:
        return 'B+';
      case BloodGroups.oPOS:
        return 'O+';
      case BloodGroups.abPOS:
        return 'AB+';
      case BloodGroups.aNEG:
        return 'A-';
      case BloodGroups.bNEG:
        return 'B-';
      case BloodGroups.oNEG:
        return 'O-';
      case BloodGroups.abNEG:
        return 'AB-';
      default:
        return 'Invalid Blood Group';
    }
  }
}

String getPrettyDate(DateTime? dateTime) => dateTime == null
    ? ''
    : '${dateTime.day}/${dateTime.month}/${dateTime.year}';
String getPrettyTime(DateTime? dateTime) => dateTime == null
    ? ''
    : '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
