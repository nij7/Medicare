import 'package:bcrud/controllers/chatController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/bookAppointmentPage.dart';
import 'package:bcrud/pages/chatListPage.dart';
import 'package:bcrud/pages/chatPage.dart';
import 'package:bcrud/pages/familylistpage.dart';
import 'package:bcrud/pages/listDoctorsPage.dart';
import 'package:bcrud/pages/doctorAppointmentList.dart';
import 'package:bcrud/pages/listMyPatients.dart';
import 'package:bcrud/pages/loginPage.dart';
import 'package:bcrud/pages/patientAppointmentList.dart';
import 'package:bcrud/pages/patientRequestPage.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //showType(String type) => type.toTitleCase();
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    final _auth = ref.watch(authControllerProvider);
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser?.type == UserTypes.doctor) {
      if (currentUser?.docstatus != Docstatus.verified) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              ClipPath(
                clipper: Customshape(),
                child: Container(
                  height: mqh * 0.4,
                  width: mq,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please wait while your profile is verified..'),
                    SizedBox(height: mq * 0.05),
                    ElevatedButton(
                        //onPressed: () => _auth.signOut(),
                        onPressed: () async {
                          await _auth.signOut();
                          ref.read(currentUserProvider.notifier).update(null);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false);
                        },
                        child: const Text('signout')),
                  ],
                ),
              )
            ],
          ),
        );
      }
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          ClipPath(
            clipper: Customshape(),
            child: Container(
              //color: Colors.green,
              height: mqh * 0.4,
              width: mq,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                //borderRadius: BorderRadius.only(
                //  bottomLeft: Radius.circular(mq * 0.15),
                //  bottomRight: Radius.circular(mq * 0.15),
                //),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: mqh * 0.2,
                  width: mq,
                  child: const Center(
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 42,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mqh * 0.05,
                  width: mq,
                  child: Center(
                    child: Text(
                      'Welcome ${currentUser?.name ?? ''}',
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mqh * 0.03,
                  child: const Center(
                    child: Text(
                      'How can we help you today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HomePageCard(
                          page: currentUser?.type == UserTypes.doctor
                              ? const ListMyPattients()
                              : const ListDoctorsPage(),
                          icon: currentUser?.type == UserTypes.doctor
                              ? Icons.people_rounded
                              : Icons.medical_services_outlined,
                          title: currentUser?.type == UserTypes.doctor
                              ? 'My Patients'
                              : 'Doctors',
                        ),
                        HomePageCard(
                          page: currentUser?.type == UserTypes.doctor
                              ? const DoctorAppointmentList()
                              : const PatientAppointmentList(),
                          icon: Icons.calendar_today,
                          title: 'My Appointments',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HomePageCard(
                          page: ChatListPage(),
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'Chats',
                        ),
                        HomePageCard(
                          page: currentUser?.type == UserTypes.doctor
                              ? const PatientRequestPage()
                              : const Familylistpage(),
                          icon: currentUser?.type == UserTypes.doctor
                              ? Icons.add_task_rounded
                              : Icons.family_restroom,
                          title: currentUser?.type == UserTypes.doctor
                              ? 'Patient Requests'
                              : 'Family',
                        ),
                      ],
                    ),
                    currentUser?.type == UserTypes.doctor
                        ? HomePageCard(
                            page: ProfilePage(user: currentUser ?? Appuser()),
                            icon: Icons.person_rounded,
                            title: 'Profile',
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HomePageCard(
                                onTap: () async {
                                  final currentUser =
                                      ref.read(currentUserProvider);
                                  //var chatId = await ChatController.getChatIdWith('', user.uid ?? '');
                                  String? chatId =
                                      await ChatController.getChatIdWith(
                                          currentUser?.uid ?? '',
                                          Appdata.botId);
                                  chatId ??=
                                      await ChatController.createChatIdWith(
                                          currentUser?.uid ?? '',
                                          Appdata.botId,
                                          'HealthBot');
                                  // bot welcm msg
                                  await ChatController.nukeAllMsgs(chatId!);
                                  await ChatController.sendMessage(
                                      Appdata.botId,
                                      chatId,
                                      "Hi ${currentUser?.name ?? "User"},");
                                  await ChatController.sendMessage(
                                      Appdata.botId,
                                      chatId,
                                      "How may I help you?"); // welcome msg
                                  return Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => ChatPage(chatId!)));
                                },
                                page: ChatPage(Appdata.botId),
                                icon: Icons.cloud,
                                title: 'Bot',
                              ),
                              HomePageCard(
                                page:
                                    ProfilePage(user: currentUser ?? Appuser()),
                                icon: Icons.person_rounded,
                                title: 'Profile',
                              ),
                            ],
                          ),
                  ],
                ),
                SizedBox(height: mq * 0.05),
                ElevatedButton(
                    //onPressed: () => _auth.signOut(),
                    onPressed: () async {
                      await _auth.signOut();
                      ref.read(currentUserProvider.notifier).update(null);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false);
                    },
                    child: const Text('signout')),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomePageCard extends StatelessWidget {
  HomePageCard({
    Key? key,
    this.icon,
    this.title,
    this.onTap,
    required this.page,
  }) : super(key: key);
  final IconData? icon;
  final String? title;
  final Widget page;
  final Function? onTap;
  final isLoadingProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    return Container(
      height: mq * 0.3,
      width: mq * 0.3,
      margin: EdgeInsets.all(mq * 0.05),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(mq * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22999999),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final isLoading = ref.watch(isLoadingProvider);
          return GestureDetector(
            onTap: () async {
              if (onTap != null) {
                ref.read(isLoadingProvider.notifier).state = true;
                await onTap!();
                // await Future.delayed(Duration(seconds: 3));
                ref.read(isLoadingProvider.notifier).state = false;
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => page));
              }
            },
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        icon ?? Icons.accessibility_new_rounded,
                        size: mq * 0.15,
                        color: AppColors.primary,
                      ),
                      Padding(
                        padding: EdgeInsets.all(mq * 0.02),
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: mq * 0.03,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
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
    path.lineTo(0, height - height * 0.2);
    path.quadraticBezierTo(width * 0.5, height, width, height - height * 0.2);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/*
doctors
profile
appointment
chat
relatives
*/