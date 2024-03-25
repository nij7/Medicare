import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientRequestPage extends ConsumerStatefulWidget {
  const PatientRequestPage({Key? key}) : super(key: key);

  @override
  _PatientRequestPageState createState() => _PatientRequestPageState();
}

class _PatientRequestPageState extends ConsumerState<PatientRequestPage> {
  List<Appuser?> pendingRequests = [];
  bool isLoading = false;
  @override
  void initState() {
    getPatientRequests();
    super.initState();
  }

  getPatientRequests() async {
    print('aah');
    try {
      setState(() {
        isLoading = true;
      });
      final currentUser = ref.read(currentUserProvider);
      List<Appuser?> result = await UserController.getPatientDetails(
          currentUser?.pendingApprovals ?? []);
      setState(() {
        isLoading = false;
        pendingRequests = result;
      });
    } catch (e) {
      mounted
          ? setState(() {
              isLoading = false;
            })
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: isLoading ? () {} : getPatientRequests,
              icon: Icon(isLoading ? Icons.close : Icons.refresh))
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: isLoading
            ? LinearProgressIndicator()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: pendingRequests.length,
                itemBuilder: (_, i) =>
                    RequestTile(patient: pendingRequests[i] ?? Appuser()),
              ),
      ),
    );
  }
}

class RequestTile extends StatelessWidget {
  const RequestTile({Key? key, required this.patient}) : super(key: key);
  final Appuser patient;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ProfilePage(user: patient))),
      title: Text(patient.name ?? ''),
      leading: const Icon(Icons.person_rounded),
    );
  }
}
