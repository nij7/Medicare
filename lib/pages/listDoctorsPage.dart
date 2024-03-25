import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListDoctorsPage extends ConsumerStatefulWidget {
  const ListDoctorsPage({Key? key}) : super(key: key);

  @override
  _ListDoctorsPageState createState() => _ListDoctorsPageState();
}

class _ListDoctorsPageState extends ConsumerState<ListDoctorsPage> {
  bool isLoading = false, isSearching = false;
  List<Appuser?> approvedDoctors = [], allDoctors = [];

  @override
  void initState() {
    getAllApprovedDoctors();
    super.initState();
  }

  getAllApprovedDoctors() async {
    setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
    approvedDoctors =
        await UserController.getAllApprovedDoctors(currentUser?.uid ?? '');
    print(approvedDoctors.length);
    setState(() => isLoading = false);
  }

  getAllDoctors() async {
    setState(() => isLoading = true);
    allDoctors = await UserController.getAllDoctors() ?? [];
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    mqh -= MediaQuery.of(context).viewPadding.top;
    mqh -= kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
        actions: [
          IconButton(
            onPressed: () {
              if (!isSearching) getAllDoctors();
              setState(() => isSearching = !isSearching);
            },
            icon: Icon(isSearching ? Icons.close : Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: mqh * 0.3,
            width: mq,
            color: AppColors.primary,
          ),
          SizedBox(
            height: mqh * 0.7,
            child: !isSearching
                ? isLoading
                    ? const LinearProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: approvedDoctors.length,
                        itemBuilder: (_, i) =>
                            DoctorTile(doctor: approvedDoctors[i] ?? Appuser()),
                      )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: allDoctors.length,
                    itemBuilder: (_, i) =>
                        DoctorTile(doctor: allDoctors[i] ?? Appuser()),
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
