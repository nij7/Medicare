// ignore_for_file: use_key_in_widget_constructors

import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListMyPattients extends ConsumerStatefulWidget {
  const ListMyPattients({Key? key}) : super(key: key);

  @override
  _ListMyPattientsState createState() => _ListMyPattientsState();
}

class _ListMyPattientsState extends ConsumerState<ListMyPattients> {
  bool isLoading = false, isSearching = false;
  List<Appuser?> getallPatients = [];
  @override
  void initState() {
    getAllPatients();
    super.initState();
  }
   getAllPatients()  async{
     setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
     getallPatients= 
        await UserController.getAllPatients(currentUser?.patients ??[] )??[];
     print(getallPatients.length);
    setState(() => isLoading = false);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My patients"),
      ),
      body: Column(
        children:  [
          
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
                    itemCount: getallPatients.length,
                    itemBuilder: (_, i) =>
                        PatientTile(patient: getallPatients[i] ?? Appuser()),
            ),
          ),
          
        ],
      ),
    );
  }
}
class PatientTile extends StatelessWidget{
const PatientTile({Key? key, required this.patient}) : super(key: key);
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
