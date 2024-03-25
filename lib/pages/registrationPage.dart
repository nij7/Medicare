import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:flutter/material.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/pages/doctorRegistrationPage.dart';
import 'package:bcrud/pages/patientRegistrationPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: mqh,
          width: mq,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const UserTypeSelectionButton(
                  registrationScreen: DoctorRegistrationPage(),
                  userType: UserTypes.doctor,
                ),
                SizedBox(height: mqh * 0.05),
                const UserTypeSelectionButton(
                  registrationScreen: PatientRegistrationPage(),
                  userType: UserTypes.patient,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserTypeSelectionButton extends StatelessWidget {
  const UserTypeSelectionButton({
    Key? key,
    required this.userType,
    required this.registrationScreen,
  }) : super(key: key);

  final String userType;
  final Widget registrationScreen;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => registrationScreen,
        ),
      ),
      child: Text(
        userType.toUpperCase(),
        style: const TextStyle(color: AppColors.secondary),
      ),
    );
  }
}
