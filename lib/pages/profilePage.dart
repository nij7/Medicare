import 'package:bcrud/controllers/chatController.dart';
import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appointmentModel.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/bookAppointmentPage.dart';
import 'package:bcrud/pages/chatPage.dart';
import 'package:bcrud/pages/doctorProfileUpdate.dart';
import 'package:bcrud/pages/patientProfileUpdate.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bcrud/utils/appExtensions.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  final Appuser user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//onTap: () {
//  Clipboard.setData(ClipboardData(text: "your text"));
//},

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool isLoading = false, isReqLoading = false, showPersonalUid = false;
  Appuser user = Appuser();
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  updateUser() async {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      user = await UserController.getUserDetails(user.uid ?? '') ?? Appuser();
      setState(() => isLoading = false);
    } catch (e) {
      user = Appuser();
      setState(() => isLoading = false);
    }
  }

  Future<void> requestApproval() async {
    try {
      setState(() => isReqLoading = true);
      final currentUser = ref.read(currentUserProvider);
      UserController.requestApproval(user.uid ?? '', [currentUser?.uid ?? '']);
      setState(() => isReqLoading = false);
      updateUser();
    } catch (e) {
      setState(() => isReqLoading = false);
    }
  }

  acceptRequest() async {
    try {
      setState(() => isReqLoading = true);
      final currentUser = ref.read(currentUserProvider);
      await UserController.acceptApprovals(
          currentUser?.uid ?? '', [user.uid ?? '']); // [patient.uid??'']);
      //UserController.requestApproval(
      //    patient.uid ?? '', [currentUser?.uid ?? '']);

      ref.read(currentUserProvider.notifier).refresh();
      updateUser();
      setState(() => isReqLoading = false);
    } catch (e) {
      setState(() => isReqLoading = false);
    }
  }

  declineRequest() async {
    try {
      setState(() => isReqLoading = true);
      final currentUser = ref.read(currentUserProvider);
      UserController.requestApproval(user.uid ?? '', [currentUser?.uid ?? '']);
      ref.read(currentUserProvider.notifier).refresh();
      updateUser();
      setState(() => isReqLoading = false);
    } catch (e) {
      setState(() => isReqLoading = false);
    }
  }

  bookAppointment() async {
    DateTime? tmpdate;
    final currentUser = ref.read(currentUserProvider);
    tmpdate = await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (date) => tmpdate = date,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(const Duration(days: 60)));
    if (tmpdate == null) return;
    await UserController.bookAppointment(AppointmentModel(
        uid: currentUser?.uid ?? '',
        pname: currentUser?.name ?? '',
        dname: user.name ?? '',
        docid: user.uid ?? '',
        status: AppointmentStatus.booked,
        phNumber: currentUser?.phoneNumber ?? '',
        dateTime: tmpdate ?? DateTime.now()));
    updateUser();
    //Navigator.pop(context);
    //Navigator.of(context)
    //    .push(MaterialPageRoute(builder: (_) => BookAppointmentPage(user)));
  }

  chat() async {
    //fULTt6pAPYh7bZuqOT91y8FGzQE3
    //UdOgX3txaiZDl8SguwwJdxxJfpY2
    final currentUser = ref.read(currentUserProvider);
    //var chatId = await ChatController.getChatIdWith('', user.uid ?? '');
    String? chatId = await ChatController.getChatIdWith(
        currentUser?.uid ?? '', user.uid ?? '');
    chatId ??= await ChatController.createChatIdWith(
        currentUser?.uid ?? '', user.uid ?? '', user.name ?? '');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ChatPage(chatId ?? '')));
  }

  revealPersonalUID() async {
    setState(() => showPersonalUid = true);
    await Future.delayed(const Duration(seconds: 5), () {
      setState(() => showPersonalUid = false);
    });
  }

  // show btn methods
  bool showAcceptBtn() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.type == UserTypes.doctor &&
        user.type == UserTypes.patient) {
      bool isPatient =
          currentUser?.pendingApprovals?.any((e) => e == user.uid) ?? false;
      return isPatient ? true : false;
    } else {
      return false;
    }
  }

  bool showRequestBtn() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.type == UserTypes.patient &&
        user.type == UserTypes.doctor) {
      bool isAlreadyRequested =
          user.pendingApprovals?.any((elm) => elm == currentUser?.uid) ?? false;
      bool isAlreadyMyDoctor =
          user.patients?.any((e) => e == currentUser?.uid) ?? false;
      return isAlreadyRequested || isAlreadyMyDoctor ? false : true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          currentUser?.uid != user.uid
              ? const SizedBox()
              : IconButton(
                  onPressed: () async {
                    if (currentUser?.uid != user.uid) return;
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => user.type == UserTypes.doctor
                            ? const DoctorProfileUpdate()
                            : const PatientProfileUpdate()));
                    await updateUser();
                  },
                  icon: const Icon(Icons.edit),
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentUser?.uid == user.uid
          ? null
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !showAcceptBtn()
                      ? const SizedBox()
                      : FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: acceptRequest,
                          label: const Text('ACCEPT'),
                        ),
                  SizedBox(width: mq * 0.02),
                  !showAcceptBtn()
                      ? const SizedBox()
                      : FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: requestApproval,
                          label: const Text('DECLINE'),
                        ),
                  SizedBox(width: mq * 0.02),
                  !showRequestBtn()
                      ? const SizedBox()
                      : FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: requestApproval,
                          label: const Text('REQUEST'),
                        ),
                  SizedBox(width: mq * 0.02),
                  FloatingActionButton(
                      heroTag: null,
                      onPressed: chat,
                      child: const Icon(Icons.chat_rounded)),
                  SizedBox(width: mq * 0.02),
                  user.type != UserTypes.doctor
                      ? const SizedBox()
                      : FloatingActionButton(
                          heroTag: null,
                          onPressed: bookAppointment,
                          child: const Icon(Icons.event),
                        ),
                ],
              ),
            ),
      body: isLoading
          ? const LinearProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipPath(
                    clipper: Customshape(),
                    child: Container(
                      height: mqh * 0.3,
                      width: mq,
                      padding: EdgeInsets.all(mq * 0.1),
                      alignment: Alignment.topCenter,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        user.type == UserTypes.doctor
                            ? Icons.medical_services_outlined
                            : Icons.person,
                        color: AppColors.secondary,
                        size: mq * 0.4,
                      ),
                    ),
                  ),
                  Text(
                    user.name ?? '',
                    style: TextStyle(
                      fontSize: mq * 0.08,
                      color: AppColors.tertiary,
                    ),
                  ),
                  ProfilePageField(
                    icon: Icons.phone,
                    value: user.phoneNumber ?? '',
                  ),
                  ProfilePageField(
                    icon: Icons.mail,
                    value: user.email ?? '',
                  ),
                  ProfilePageField(
                    icon: Icons.text_rotation_angleup_rounded,
                    value: user.age?.toString() ?? '',
                  ),
                  user.type != UserTypes.patient
                      ? SizedBox()
                      : ProfilePageField(
                          icon: Icons.bloodtype,
                          value: AppUtils.getBloodGroup(user.bloodGroup ?? ''),
                        ),
                  user.type != UserTypes.doctor
                      ? SizedBox()
                      : ProfilePageField(
                          icon: Icons.bloodtype,
                          value: user.specialization?.toTitleCase(),
                        ),
                  ProfilePageField(
                    icon: Icons.home,
                    value: user.address ?? '',
                  ),
                  user.type != UserTypes.doctor
                      ? SizedBox()
                      : ProfilePageField(
                          icon: Icons.fact_check,
                          value: user.workExperience?.toString() ?? '',
                        ),
                  Text(
                    user.about ?? '',
                    style: TextStyle(
                      fontSize: mq * 0.04,
                      color: AppColors.tertiary,
                    ),
                  ),
                  currentUser?.uid == user.uid &&
                          currentUser?.type == UserTypes.patient
                      ? MaterialButton(
                          onPressed: revealPersonalUID,
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: !showPersonalUid
                              ? const Text(
                                  'Reveal My Personal ID',
                                  style: TextStyle(color: AppColors.secondary),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentUser?.uid ?? '',
                                      style: const TextStyle(
                                          color: AppColors.secondary),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => Clipboard.setData(
                                          ClipboardData(
                                              text: currentUser?.uid ?? '')),
                                      color: AppColors.secondary,
                                      icon: const Icon(Icons.copy_rounded),
                                    )
                                  ],
                                ),
                        )
                      : const SizedBox(),
                  user.type != UserTypes.patient
                      ? const SizedBox()
                      : SizedBox(
                          height: mqh * 0.5,
                          width: mq,
                          child:
                              ListFamilyMembers(uids: user.familyMembers ?? []),
                        )
                ],
              ),
            ),
    );
  }
}

class ProfilePageField extends StatelessWidget {
  const ProfilePageField({Key? key, this.icon, this.value}) : super(key: key);
  final IconData? icon;
  final String? value;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: mq * 0.02),
      child: Row(
        children: [
          Container(
            height: mq * 0.1,
            width: mq * 0.1,
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          Container(
            width: mq * 0.05,
            // color: Colors.blue,
            child: Text(
              ' : ',
              style: TextStyle(
                fontSize: mq * 0.04,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
          Container(
            width: mq * 0.8,
            // color: Colors.red,
            child: Text(
              value ?? '',
              maxLines: 3,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: mq * 0.04,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, height - 0);
    path.quadraticBezierTo(width * 0.5, height * 0.7, width, height - 0);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ListFamilyMembers extends StatefulWidget {
  ListFamilyMembers({Key? key, required this.uids}) : super(key: key);
  List<String> uids;

  @override
  _ListFamilyMembersState createState() => _ListFamilyMembersState();
}

class _ListFamilyMembersState extends State<ListFamilyMembers> {
  bool isLoading = false;
  List<Appuser?> familyMembers = [];

  @override
  void initState() {
    getAllFamilyMembers();
    super.initState();
  }

  getAllFamilyMembers() async {
    setState(() => isLoading = true);
    familyMembers = await UserController.getAllUsers(widget.uids) ?? [];
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(mq * 0.02),
            alignment: Alignment.topLeft,
            child: const Text('Family Members'),
          ),

          isLoading
              ? const LinearProgressIndicator()
              : SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: familyMembers.length,
                    itemBuilder: (_, i) =>
                        DoctorTile(doctor: familyMembers[i] ?? Appuser()),
                  ),
                ),
          //for (int i = 0; i < _length; i++)
          //  DoctorTile(doctor: doctors?[i] ?? Appuser()),
        ],
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  const DoctorTile({Key? key, required this.doctor}) : super(key: key);
  final Appuser doctor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ProfilePage(user: doctor))),
      title: Text(doctor.name ?? ''),
      leading: const Icon(Icons.person_rounded),
    );
  }
}
