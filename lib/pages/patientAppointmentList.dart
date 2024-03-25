import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/models/appointmentModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/pages/resheduleAppontment.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/utils/appUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientAppointmentList extends ConsumerStatefulWidget {
  const PatientAppointmentList({Key? key}) : super(key: key);

  @override
  _PatientAppointmentListState createState() => _PatientAppointmentListState();
}

class _PatientAppointmentListState
    extends ConsumerState<PatientAppointmentList> {
  List<AppointmentModel?> myAppointments = [];
  bool isLoading = false;

  @override
  void initState() {
    getMyAppointments();
    super.initState();
  }

  getMyAppointments() async {
    setState(() => isLoading = true);
    final currentUser = ref.read(currentUserProvider);
    myAppointments = await UserController.getAllMyAppointments(
            'uid', currentUser?.uid ?? "") ??
        [];
    DateTime _t = DateTime(4045);
    myAppointments
        .sort((a, b) => a?.dateTime?.compareTo(b?.dateTime ?? _t) ?? 0);
    // print(myAppointments.length);
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          1: FixedColumnWidth(80),
                        },
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
                                      'status',
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
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(0),
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    color: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    elevation: 0,
                                    highlightElevation: 0,
                                    focusElevation: 0,
                                    hoverElevation: 0,
                                    disabledElevation: 0,
                                    onPressed: () async {
                                      var user =
                                          await UserController.getUserDetails(
                                              myAppointments[i]?.docid ?? '');
                                      if (user == null) return;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ProfilePage(user: user)));
                                    },
                                    child: Text(myAppointments[i]?.dname ?? '',
                                        style: TextStyle(fontSize: 10.0)),
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
                                  child: Row(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: IconButton(
                                          tooltip: 'Cancel',
                                          onPressed: () async {
                                            await UserController
                                                .cancelAppointment(
                                                    myAppointments[i]?.id ??
                                                        '');
                                            getMyAppointments();
                                          },
                                          color: Colors.deepOrangeAccent,
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: IconButton(
                                          tooltip: 'Reschedule',
                                          onPressed: () async {
                                            DateTime? tempdate;
                                            tempdate = await DatePicker
                                                .showDateTimePicker(context,
                                                    showTitleActions: true,
                                                    onChanged: (date) =>
                                                        tempdate = date,
                                                    //onChanged: (time) {
                                                    //  return tempdate = time;
                                                    //},
                                                    minTime: DateTime.now(),
                                                    maxTime: DateTime.now().add(
                                                        const Duration(
                                                            days: 60)));
                                            await UserController
                                                .rescheduleAppointment(
                                                    myAppointments[i]?.id ?? '',
                                                    tempdate ?? DateTime.now());
                                            getMyAppointments();
                                          },
                                          color: Colors.deepOrangeAccent,
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      )),
                ],
              ),
            ),
    );
  }
}
