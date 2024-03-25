import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Familylistpage extends ConsumerStatefulWidget {
  const Familylistpage({Key? key}) : super(key: key);

  @override
  _FamilylistpageState createState() => _FamilylistpageState();
}

class _FamilylistpageState extends ConsumerState<Familylistpage> {
  final TextEditingController _textFieldController = TextEditingController();
  String familyMemberId = '';
  bool isLoading = false, isSearching = false;
  List<Appuser?> myFamilyMembers = [];
  //var usersub;

  @override
  void initState() {
    getAllFamilyMembers();

    super.initState();
  }

  @override
  void dispose() {
    //closeCurrentUserStream();
    super.dispose();
  }

  getAllFamilyMembers() async {
    setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
    myFamilyMembers =
        await UserController.getAllUsers(currentUser?.familyMembers ?? []) ??
            [];
    setState(() => isLoading = false);
  }

  addFamilyMember() async {
    setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
    await UserController.addFamilyMembers(
        currentUser?.uid ?? '', [familyMemberId]);
    ref.read(currentUserProvider.notifier)
      .update(await UserController.getUserDetails(currentUser?.uid ?? ''));
    getAllFamilyMembers();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    //getAllFamilyMembers();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                _displayTextInputDialog(context);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            color: AppColors.primary,
          ),
          isLoading
              ? const LinearProgressIndicator()
              : SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: myFamilyMembers.length,
                    itemBuilder: (_, i) {
                      return FamilyMemberTile(
                          patient: myFamilyMembers[i] ?? Appuser());
                    },
                  ),
                )
        ]));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter your Relative's id"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  familyMemberId = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "ID"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    addFamilyMember();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}

class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({Key? key, required this.patient}) : super(key: key);
  final Appuser patient;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ProfilePage(user: patient))),
      title: Text(patient.name ?? ''),
      leading: const Icon(Icons.person_rounded),
    );
  }
}
