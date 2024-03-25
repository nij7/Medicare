import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appointmentModel.dart';
//import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
//import 'package:bcrud/pages/resheduleAppontment.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appUtils.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/transparantButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorAppointmentList extends ConsumerStatefulWidget {
  const DoctorAppointmentList({Key? key}) : super(key: key);

  @override
  _DoctorAppointmentListState createState() => _DoctorAppointmentListState();
}

class _DoctorAppointmentListState extends ConsumerState<DoctorAppointmentList> {
  List<AppointmentModel?> myAppointments = [];
  bool isLoading = false;
  //List<Appuser?> localUserData = [];

  @override
  void initState() {
    getMyAppointments();
    super.initState();
  }

  getMyAppointments() async {
    setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
    myAppointments = await UserController.getAllMyAppointments(
            'docid', currentUser?.uid ?? "") ??
        [];
    print(myAppointments.length);
    setState(() => isLoading = false);
    //List<String> tmpuids = [];
    //myAppointments.map((e) => tmpuids.add(e?.uid??''));
    //localUserData = await UserController.getAllUsers(tmpuids) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? LinearProgressIndicator()
          : Column (
              children: [
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(),
                        //columnWidths: const <int, TableColumnWidth>{
                        //  1: FixedColumnWidth(80),
                        //},
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
                              //TableCell(
                              //  child: Container(
                              //    color: Colors.greenAccent,
                              //    child: const Center(
                              //      child: Text(
                              //        'phone number',
                              //        style: TextStyle(
                              //          fontSize: 10.0,
                              //          fontWeight: FontWeight.bold,
                              //        ),
                              //      ),
                              //    ),
                              //  ),
                              //),
                              TableCell(
                                child: Container(
                                  color: Colors.greenAccent,
                                  child: const Center(
                                    child: Text(
                                      'Status',
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
                                      'Date',
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
                                      'Time',
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
                          for (var i = 0; i < myAppointments.length; i++) ...[
                            TableRow(
                              children: [
                                TableCell(
                                  child: TransparantButton(
                                    //index: i,
                                    //myAppointments: myAppointments,
                                    onTap: () async {
                                      var user =
                                          await UserController.getUserDetails(
                                              myAppointments[i]?.uid ?? '');
                                      if (user == null) return;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ProfilePage(
                                            user: user,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(myAppointments[i]?.pname ?? '',
                                        style: const TextStyle(fontSize: 10.0)),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(
                                          myAppointments[i]?.status ?? '',
                                          style: TextStyle(fontSize: 10.0))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(
                                          getPrettyDate(
                                              myAppointments[i]?.dateTime),
                                          style: TextStyle(fontSize: 10.0))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(
                                          getPrettyTime(
                                              myAppointments[i]?.dateTime),
                                          style: TextStyle(fontSize: 10.0))),
                                ),
                                TableCell(
                                  child: TransparantButton(
                                      onTap: () async {
                                        await await showOptionDialod(
                                            context, i);
                                        //if (reload) getMyAppointments();
                                      },
                                      child: const Icon(Icons.pending,
                                          color: AppColors.secondaryAccent)),
                                  //child: Row(
                                  //  mainAxisAlignment: MainAxisAlignment.center,
                                  //  mainAxisSize: MainAxisSize.min,
                                  //  children: [
                                  //    SizedBox(
                                  //      height: 40,
                                  //      width: 40,
                                  //      child: IconButton(
                                  //        onPressed: () => {},
                                  //        color: Colors.deepOrangeAccent,
                                  //        icon: const Icon(
                                  //          Icons.done,
                                  //          color: Colors.green,
                                  //          size: 18,
                                  //        ),
                                  //      ),
                                  //    ),
                                  //    SizedBox(
                                  //      height: 40,
                                  //      width: 40,
                                  //      child: IconButton(
                                  //        padding: EdgeInsets.all(0),
                                  //        onPressed: () => {},
                                  //        icon: const Icon(
                                  //          Icons.cancel,
                                  //          color: Colors.red,
                                  //          size: 18,
                                  //        ),
                                  //      ),
                                  //    ),
                                  //  ],
                                  //),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    )),
                //const Text("approved list"),
                //Container(
                //    margin:
                //        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                //    child: SingleChildScrollView(
                //      scrollDirection: Axis.vertical,
                //      child: Table(
                //        border: TableBorder.all(),
                //        columnWidths: const <int, TableColumnWidth>{
                //          1: FixedColumnWidth(80),
                //        },
                //        defaultVerticalAlignment:
                //            TableCellVerticalAlignment.middle,
                //        children: [
                //          TableRow(
                //            children: [
                //              TableCell(
                //                child: Container(
                //                  color: Colors.greenAccent,
                //                  child: const Center(
                //                    child: Text(
                //                      'Name',
                //                      style: TextStyle(
                //                        fontSize: 10.0,
                //                        fontWeight: FontWeight.bold,
                //                      ),
                //                    ),
                //                  ),
                //                ),
                //              ),
                //              TableCell(
                //                child: Container(
                //                  color: Colors.greenAccent,
                //                  child: const Center(
                //                    child: Text(
                //                      'phone number',
                //                      style: TextStyle(
                //                        fontSize: 10.0,
                //                        fontWeight: FontWeight.bold,
                //                      ),
                //                    ),
                //                  ),
                //                ),
                //              ),
                //              TableCell(
                //                child: Container(
                //                  color: Colors.greenAccent,
                //                  child: const Center(
                //                    child: Text(
                //                      'Date',
                //                      style: TextStyle(
                //                        fontSize: 10.0,
                //                        fontWeight: FontWeight.bold,
                //                      ),
                //                    ),
                //                  ),
                //                ),
                //              ),
                //              TableCell(
                //                child: Container(
                //                  color: Colors.greenAccent,
                //                  child: const Center(
                //                    child: Text(
                //                      'Time',
                //                      style: TextStyle(
                //                        fontSize: 10.0,
                //                        fontWeight: FontWeight.bold,
                //                      ),
                //                    ),
                //                  ),
                //                ),
                //              ),
                //              TableCell(
                //                child: Container(
                //                  color: Colors.greenAccent,
                //                  child: const Center(
                //                    child: Text(
                //                      'Action',
                //                      style: TextStyle(
                //                        fontSize: 10.0,
                //                        fontWeight: FontWeight.bold,
                //                      ),
                //                    ),
                //                  ),
                //                ),
                //              ),
                //            ],
                //          ),
                //          for (var i = 0; i < myAppointments.length; i++) ...[
                //            TableRow(
                //              children: [
                //                TableCell(
                //                  child: Center(
                //                      child: Text(myAppointments[i]?.pname ?? '',
                //                          style: TextStyle(fontSize: 10.0))),
                //                ),
                //                TableCell(
                //                  child: Center(
                //                      child: Text(
                //                          myAppointments[i]?.phNumber ?? '',
                //                          style: TextStyle(fontSize: 10.0))),
                //                ),
                //                TableCell(
                //                  child: Center(
                //                      child: Text(
                //                          getPrettyDate(
                //                              myAppointments[i]?.dateTime),
                //                          style: TextStyle(fontSize: 10.0))),
                //                ),
                //                TableCell(
                //                  child: Center(
                //                      child: Text(
                //                          getPrettyTime(
                //                              myAppointments[i]?.dateTime),
                //                          style: TextStyle(fontSize: 10.0))),
                //                ),
                //                TableCell(
                //                  child: Row(
                //                    mainAxisAlignment: MainAxisAlignment.center,
                //                    children: [
                //                      SizedBox(
                //                        height: 40,
                //                        width: 40,
                //                        child: IconButton(
                //                          onPressed: () => {
                //                            Navigator.of(context).push(
                //                                MaterialPageRoute(
                //                                    builder: (_) =>
                //                                        const resheduleAppointment()))
                //                          },
                //                          color: Colors.deepOrangeAccent,
                //                          icon: const Icon(
                //                            Icons.edit,
                //                            color: Colors.orange,
                //                            size: 18,
                //                          ),
                //                        ),
                //                      ),
                //                    ],
                //                  ),
                //                ),
                //              ],
                //            ),
                //          ],
                //        ],
                //      ),
                //    )),
              ],
            ),
    );
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
                if (myAppointments[i]?.status == AppointmentStatus.cancelled) {
                  return Navigator.pop(context);
                }
                await UserController.acceptAppointment(
                    myAppointments[i]?.id ?? '');
                getMyAppointments();
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
                if (myAppointments[i]?.status == AppointmentStatus.cancelled) {
                  return Navigator.pop(context);
                }
                DateTime? tempdate;
                tempdate = await DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    onChanged: (date) => tempdate = date,
                    //onChanged: (time) {
                    //  return tempdate = time;
                    //},
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(const Duration(days: 60)));
                await UserController.rescheduleAppointment(
                    myAppointments[i]?.id ?? '', tempdate ?? DateTime.now());
                getMyAppointments();
                Navigator.pop(context, true);
              },
              bg: Colors.orange,
              child: const Text(
                'RE SCHEDULE',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () async {
                if (myAppointments[i]?.status == AppointmentStatus.cancelled) {
                  return Navigator.pop(context);
                }
                await UserController.declineAppointment(
                    myAppointments[i]?.id ?? '');
                getMyAppointments();
                Navigator.pop(context, true);
              },
              bg: Colors.red,
              child: const Text(
                'DECLINE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
