import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/pages/adAllDoctor.dart';
import 'package:bcrud/pages/adDocAccept.dart';
import 'package:bcrud/pages/adDocRejected.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adAllPatient.dart';
import 'homePage.dart';
import 'loginPage.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  bool isloading = false;
 @override
 void setState(VoidCallback fn) {
    // TODO: implement setState
    
    isloading = !isloading;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    final _auth = ref.watch(authControllerProvider);
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser != null
    ) {
      setState(() { 
        isloading = false;
      });
    }
    return Scaffold(
      
      backgroundColor: AppColors.background,
      body: isloading == true ? const CircularProgressIndicator() : Stack(
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
                      children: [
                        HomePageCard(
                          page: AdAllPatient(),
                          icon: Icons.people_rounded,
                          title: 'All patients',
                        ),
                        HomePageCard(
                          page: AdAllDoctor(),
                          icon: Icons.medical_services_outlined,
                          title: 'All Doctors',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HomePageCard(
                          page: AdDocAccept(),
                          icon: Icons.people_rounded,
                          title: 'Accepted Doctor',
                        ),
                        HomePageCard(
                          page: AdDocRejected(),
                          icon: Icons.medical_services_outlined,
                          title: 'Rejected Doctors',
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
          ),
        ],
      ),
    );
  }
}
