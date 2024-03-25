import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appointmentModel.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookAppointmentPage extends ConsumerStatefulWidget {
  const BookAppointmentPage(this.doctor, {Key? key}) : super(key: key);
  final Appuser doctor;

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends ConsumerState<BookAppointmentPage> {
  String _date = "Not set";
  String _time = "Not set";
  DateTime? appointmentTime;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  //var tmpdate = await showDatePicker(
                  //  context: context,
                  //  firstDate: DateTime.now(),
                  //  initialDate: DateTime.now(),
                  //  lastDate: DateTime.now().add(const Duration(days: 60)),
                  //  initialDatePickerMode: DatePickerMode.year,
                  //);
                  //var temptime = await showTimePicker(
                  //    context: context, initialTime: TimeOfDay.now());

                  //appointmentTime = tmpdate;
                  await DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) => appointmentTime = date,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(const Duration(days: 60)));
                  if (appointmentTime == null) return;
                  await UserController.bookAppointment(AppointmentModel(
                    uid: currentUser?.uid ?? '',
                    pname: currentUser?.name ??'',
                    dname: widget.doctor.name ?? '',
                    docid: widget.doctor.uid ?? '',
                    status: AppointmentStatus.booked,
                    phNumber: currentUser?.phoneNumber ?? '',
                    dateTime: appointmentTime ?? DateTime.now()
                  ));
                  Navigator.pop(context);
                },
                child: Text(
                  'BOOK APPOINTMENT',
                  style: TextStyle(color: Colors.blue),
                )),
            //  MaterialButton(
            //  onPressed: () {
            //    UserController.bookAppointment(currentUser?.uid ?? '',
            //        widget.doctor.uid ?? '', DateTime.now());
            //  },
            //  child: const Text('Book Appointment'),
            //),
          ],
        ),
      ),
      //body: Padding(
      //  padding: const EdgeInsets.all(16.0),
      //  child: Container(
      //    child: Column(
      //      mainAxisSize: MainAxisSize.max,
      //      mainAxisAlignment: MainAxisAlignment.center,
      //      children: <Widget>[
      //        RaisedButton(
      //          shape: RoundedRectangleBorder(
      //              borderRadius: BorderRadius.circular(5.0)),
      //          elevation: 4.0,
      //          onPressed: () {
      //            DatePicker.showDatePicker(context,
      //                theme: DatePickerTheme(
      //                  containerHeight: 210.0,
      //                ),
      //                onChanged: (time) => appointmentTime = time,
      //                showTitleActions: true,
      //                minTime: DateTime(2018, 1, 1),
      //                maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
      //              print('confirm $date');
      //              _date = '${date.year} - ${date.month} - ${date.day}';
      //              setState(() {});
      //            }, currentTime: DateTime.now(), locale: LocaleType.en);
      //          },
      //          child: Container(
      //            alignment: Alignment.center,
      //            height: 50.0,
      //            child: Row(
      //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //              children: <Widget>[
      //                Row(
      //                  children: <Widget>[
      //                    Container(
      //                      child: Row(
      //                        children: <Widget>[
      //                          Icon(
      //                            Icons.date_range,
      //                            size: 18.0,
      //                            color: Colors.teal,
      //                          ),
      //                          Text(
      //                            " $_date",
      //                            style: TextStyle(
      //                                color: Colors.teal,
      //                                fontWeight: FontWeight.bold,
      //                                fontSize: 18.0),
      //                          ),
      //                        ],
      //                      ),
      //                    )
      //                  ],
      //                ),
      //                Text(
      //                  "  Change",
      //                  style: TextStyle(
      //                      color: Colors.teal,
      //                      fontWeight: FontWeight.bold,
      //                      fontSize: 18.0),
      //                ),
      //              ],
      //            ),
      //          ),
      //          color: Colors.white,
      //        ),
      //        SizedBox(
      //          height: 20.0,
      //        ),
      //        RaisedButton(
      //          shape: RoundedRectangleBorder(
      //              borderRadius: BorderRadius.circular(5.0)),
      //          elevation: 4.0,
      //          onPressed: () {
      //            DatePicker.showTimePicker(context,
      //                theme: DatePickerTheme(
      //                  containerHeight: 210.0,
      //                ),
      //                showTitleActions: true, onConfirm: (time) {
      //              print('confirm $time');
      //              _time = '${time.hour} : ${time.minute} : ${time.second}';
      //              setState(() {});
      //            }, currentTime: DateTime.now(), locale: LocaleType.en);
      //            setState(() {});
      //          },
      //          child: Container(
      //            alignment: Alignment.center,
      //            height: 50.0,
      //            child: Row(
      //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //              children: <Widget>[
      //                Row(
      //                  children: <Widget>[
      //                    Container(
      //                      child: Row(
      //                        children: <Widget>[
      //                          Icon(
      //                            Icons.access_time,
      //                            size: 18.0,
      //                            color: Colors.teal,
      //                          ),
      //                          Text(
      //                            " $_time",
      //                            style: TextStyle(
      //                                color: Colors.teal,
      //                                fontWeight: FontWeight.bold,
      //                                fontSize: 18.0),
      //                          ),
      //                        ],
      //                      ),
      //                    )
      //                  ],
      //                ),
      //                Text(
      //                  "  Change",
      //                  style: TextStyle(
      //                      color: Colors.teal,
      //                      fontWeight: FontWeight.bold,
      //                      fontSize: 18.0),
      //                ),
      //              ],
      //            ),
      //          ),
      //          color: Colors.white,
      //        ),
      //        MaterialButton(
      //          onPressed: () {
      //            UserController.bookAppointment(currentUser?.uid ?? '',
      //                widget.doctor.uid ?? '', DateTime.now());
      //          },
      //          child: const Text('Book Appointment'),
      //        ),
      //      ],
      //    ),
      //  ),
      //),
    );
  }
}
