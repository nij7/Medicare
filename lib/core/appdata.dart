import 'package:flutter/material.dart';

class Appdata {
  static String name = 'MediCare';
  static String botId = 'KIFlxrN08A9DYlJ0CYBm';
}

abstract class UserTypes {
  static const String bot = 'BOT';
  static const String doctor = 'DOCTOR';
  static const String patient = 'PATIENT';
  static const String admin = 'ADMIN';
}

abstract class Docstatus {
  static const String verified = 'VERIFIED';
  static const String notVerified = 'NOTVERIFIED';
  static const String rejected = 'REJECTED';
}

abstract class AppointmentStatus {
  // by user
  static const String booked = 'BOOKED';
  static const String cancelled = 'CANCELLED';
  // by doctor
  static const String approved = 'APPROVED';
  static const String declined = 'DECLINED';
  static const String rescheduled = 'RESCHEDULED';
}

abstract class BloodGroups {
  static const String aPOS = 'aPOS';
  static const String bPOS = 'bPOS';
  static const String oPOS = 'oPOS';
  static const String abPOS = 'abPOS';
  static const String aNEG = 'aNEG';
  static const String bNEG = 'bNEG';
  static const String oNEG = 'oNEG';
  static const String abNEG = 'abNEG';
}

abstract class DoctorSpecializations {
  static const String oncology = 'ONCOLOGY';
  static const String cardiology = 'CARDIOLOGY';
  static const String neurology = 'NEUROLOGY';
  static const String paediatrics = 'PAEDIATRICS';
  static const String otolaryngologists = 'OTOLARYNGOLOGIST';
  static const String ophthalmologist = 'OPHTHALMOLOGIST';
  static const String dermatologist = 'DERMATOLOGIST';
}
