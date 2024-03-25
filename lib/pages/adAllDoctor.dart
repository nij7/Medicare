import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
// import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/transparantButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdAllDoctor extends ConsumerStatefulWidget {
  const AdAllDoctor({Key? key}) : super(key: key);

  @override
  _AdAllDoctorState createState() => _AdAllDoctorState();
}

class _AdAllDoctorState extends ConsumerState<AdAllDoctor> {
  bool isLoading = false, isSearching = false;
  List<Appuser?> allDoctors = [];

  @override
  void initState() {
    getAllDoctors();
    super.initState();
  }

  getAllDoctors() async {
    setState(() => isLoading = true);
    allDoctors = await UserController.getAllDoctors() ?? [];
    setState(() => isLoading = false);
    print(allDoctors.length);
    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: const Center(
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: const Center(
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: const Center(
                                  child: Text(
                                    'PhoneNo',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: const Center(
                                  child: Text(
                                    'Action',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var i = 0; i < allDoctors.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: TransparantButton(
                                  onTap: () async {
                                    var user =
                                        await UserController.getUserDetails(
                                            allDoctors[i]?.uid ?? '');
                                    if (user == null) return;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProfilePage(
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(allDoctors[i]?.name ?? '',
                                      style: const TextStyle(fontSize: 10.0)),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text(allDoctors[i]?.email ?? '',
                                        style: TextStyle(fontSize: 10.0))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text(
                                        allDoctors[i]?.phoneNumber ?? '',
                                        style: TextStyle(fontSize: 10.0))),
                              ),
                              TableCell(
                                child: TransparantButton(
                                    onTap: () async {
                                      await await showOptionDialod(context, i);
                                    },
                                    child: const Icon(Icons.pending,
                                        color: AppColors.secondaryAccent)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ));
  }

  showOptionDialod(BuildContext context, int i) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: () async {
                // ithenthina? jan  not verified anel action cheyyan appointment nokki cheythatha
                // if (allDoctors[i]?.docstatus == Docstatus.notVerified) {
                // //  e line exit aakane alle
                // // njan ithu comment cheiyuva
                //   return Navigator.pop(context);
                // }
                await UserController.acceptdoctor(allDoctors[i]?.uid ?? '');

                Navigator.pop(context);
              },
              bg: Colors.green,
              child: const Text(
                'ACCEPT',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () async {
                 // if (allDoctors[i]?.docstatus == Docstatus.notVerified) {
                // //  e line exit aakane alle
                // // njan ithu comment cheiyuva
                //   return Navigator.pop(context);
                // }
                await UserController.rejectdoctor(allDoctors[i]?.uid ?? '');

                Navigator.pop(context);
              },
              bg: Colors.green,
              child: const Text(
                'REJECT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
