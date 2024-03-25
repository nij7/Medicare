import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/homePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appUtils.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/appInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientRegistrationPage extends ConsumerStatefulWidget {
  const PatientRegistrationPage({Key? key}) : super(key: key);

  @override
  _PatientRegistrationPageState createState() =>
      _PatientRegistrationPageState();
}

class _PatientRegistrationPageState
    extends ConsumerState<PatientRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _bloodgroup;
  bool isLoading = false;
  bool showError = false;
  String errorText = '';

  registerUser() async {
    try {
      setState(() {
        isLoading = true;
        showError = false;
        errorText = '';
      });
      if (_emailController.text.isEmpty) {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'email cannot be empty';
        });
        return;
      } else if (_passwordController.text != _confirmPassword.text) {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'passwords do not match';
        });
        return;
      }
     
      else if (_phonenumberController.text.length != 10) {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'enter valid phone number';
        });
        return;
      }
      
      final _auth = ref.watch(authControllerProvider);
      final _createFBuserResult = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (_createFBuserResult == 'ok') {
        Appuser _newUser = Appuser(
          uid: _auth.currentUser!.uid,
          age: int.tryParse(_ageController.text),
          type: UserTypes.patient,
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phonenumberController.text,
          bloodGroup: _bloodgroup,
          address: _addressController.text,
        );
        String _createuserResult = await UserController.createUser(_newUser);
        if (_createuserResult == 'ok') {
          Appuser? _user = await UserController.getUserDetails(_auth.currentUser!.uid);
          ref.read(currentUserProvider.notifier).update(_user);
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
            showError = true;
            errorText = 'Error!';
          });
          return;
        }
      } else if (_createFBuserResult == 'email-already-in-use') {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'Email already in use';
        });
        return;
      } else {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'Error!';
        });
        return;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        showError = true;
        errorText = 'Error!';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(mq * 0.02),
            child: Column(
              children: [
                showError
                    ? Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(mq * 0.02),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq * 0.02),
                            border: Border.all(
                              color: AppColors.errorColor,
                              width: mq * 0.002,
                            )),
                        child: Text(
                          errorText,
                          style: const TextStyle(color: AppColors.errorColor),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _nameController,
                  hintText: 'Enter Your Name',
                  icon: Icons.account_circle,
                ),
                SizedBox(height: mq * 0.02),
                DropdownButton<String>(
                  value: _bloodgroup,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  elevation: 0,
                  hint: const Text('Select your Blood Group'),
                  onChanged: (value) => setState(() => _bloodgroup = value!),
                  items: <String>[
                    BloodGroups.aPOS,
                    BloodGroups.aNEG,
                    BloodGroups.bPOS,
                    BloodGroups.bNEG,
                    BloodGroups.oPOS,
                    BloodGroups.oNEG,
                    BloodGroups.abPOS,
                    BloodGroups.abNEG,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          width: mq * 0.88,
                          child: Text(AppUtils.getBloodGroup(value))),
                    );
                  }).toList(),
                  //items: [
                  //  //DropdownMenuItem(child: Container(child: Text(BloodGroups.aPOS)))
                  //  //BloodGroupSelectionItem(bloodGroup: BloodGroups.aPOS),
                  //],
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _emailController,
                  hintText: 'Enter Your Email',
                  icon: Icons.mail,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _passwordController,
                  hintText: 'Enter Your Password',
                  icon: Icons.password,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _confirmPassword,
                  hintText: 'Confirm Your Password',
                  icon: Icons.password,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _ageController,
                  hintText: 'Enter Your Age',
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _phonenumberController,
                  hintText: 'Enter Your Contact Number',
                  icon: Icons.phone,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _addressController,
                  hintText: 'Enter Your Address',
                  icon: Icons.home,
                ),
                SizedBox(height: mq * 0.02),
                SizedBox(height: mq * 0.02),
                isLoading
                    ? const CircularProgressIndicator()
                    : AppButton(
                        onPressed: registerUser,
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(
                            color: AppColors.secondary,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
