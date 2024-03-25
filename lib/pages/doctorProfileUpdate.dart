import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appExtensions.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/appInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorProfileUpdate extends ConsumerStatefulWidget {
  const DoctorProfileUpdate({Key? key}) : super(key: key);

  @override
  _DoctorProfileUpdateState createState() => _DoctorProfileUpdateState();
}

class _DoctorProfileUpdateState extends ConsumerState<DoctorProfileUpdate> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _workExperienceController =
      TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String? _specialization;
  bool isLoading = false;
  bool showError = false;
  String errorText = '';
  @override
  void initState() {
    super.initState();
    fetchdocdata();
  }

  updatedocUser() async {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      await UserController.updatedocUser(
        uid: currentUser?.uid ?? '',
        name: _nameController.text,
        about: _aboutController.text,
        address: _addressController.text,
        specialization: _specialization,
        phonenumber: _phonenumberController.text,
        age: int.parse(_ageController.text),
        workExperience: int.parse(_workExperienceController.text),
      );
      ref.read(currentUserProvider.notifier)
        .update(await UserController.getUserDetails(currentUser?.uid ?? ''));
      Navigator.pop(context);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  fetchdocdata() {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      _nameController.text = currentUser?.name ?? '';
      _ageController.text = currentUser?.age?.toString() ?? '';
      _workExperienceController.text =
          currentUser?.workExperience?.toString() ?? '';
      _specialization = currentUser?.specialization ?? '';
      _aboutController.text = currentUser?.about ?? '';
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
                  value: _specialization,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  elevation: 0,
                  hint: const Text('Select Specialization'),
                  onChanged: (value) =>
                      setState(() => _specialization = value!),
                  items: <String>[
                    DoctorSpecializations.oncology,
                    DoctorSpecializations.cardiology,
                    DoctorSpecializations.neurology,
                    DoctorSpecializations.paediatrics,
                    DoctorSpecializations.otolaryngologists,
                    DoctorSpecializations.ophthalmologist,
                    DoctorSpecializations.dermatologist,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          width: mq * 0.89, child: Text(value.toTitleCase())),
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
                  icon: Icons.format_list_numbered,
                ),
                SizedBox(height: mq * 0.02),
                AppInputField(
                  textEditingController: _workExperienceController,
                  hintText: 'Enter Your Work Experience',
                  icon: Icons.work,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                AppInputField(
                    textEditingController: _aboutController,
                    hintText: 'About',
                    icon: Icons.list_alt_rounded),
                SizedBox(height: mq * 0.02),
                SizedBox(height: mq * 0.02),
                isLoading
                    ? const CircularProgressIndicator()
                    : AppButton(
                        onPressed: updatedocUser,
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
