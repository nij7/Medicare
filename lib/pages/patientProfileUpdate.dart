import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appUtils.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/appInputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientProfileUpdate extends ConsumerStatefulWidget {
  const PatientProfileUpdate({Key? key}) : super(key: key);

  @override
  _PatientProfileUpdateState createState() => _PatientProfileUpdateState();
}

class _PatientProfileUpdateState extends ConsumerState<PatientProfileUpdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _bloodgroup;
  bool isLoading = false;
  bool showError = false;
  String errorText = '';
  @override
  void initState() {
    super.initState();
    fetchuserdata();
  }

  CollectionReference students =
      FirebaseFirestore.instance.collection('patients');

  updateUser() async {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      await UserController.updateUser(
          currentUser?.uid ?? '',
          _nameController.text,
          _addressController.text,
          _bloodgroup,
          _phonenumberController.text,
          int.parse(_ageController.text));
      ref.read(currentUserProvider.notifier)
        .update(await UserController.getUserDetails(currentUser?.uid ?? ''));
      Navigator.pop(context);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  fetchuserdata() {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      _nameController.text = currentUser?.name ?? '';
      _ageController.text = currentUser?.age?.toString() ?? '';
      _bloodgroup = currentUser?.bloodGroup ?? '';
      _phonenumberController.text = currentUser?.phoneNumber ?? '';
      _addressController.text = currentUser?.address ?? '';

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
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
                  textEditingController: _ageController,
                  hintText: 'Enter Your Age',
                  icon: Icons.account_circle,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _phonenumberController,
                  hintText: 'Enter Your Contact Number',
                  icon: Icons.account_circle,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _addressController,
                  hintText: 'Enter Your Address',
                  icon: Icons.account_circle,
                ),
                SizedBox(height: mq * 0.02),
                SizedBox(height: mq * 0.02),
                isLoading
                    ? const CircularProgressIndicator()
                    : AppButton(
                        onPressed: updateUser,
                        child: const Text(
                          'Update Profile',
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
