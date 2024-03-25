import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/profilePage.dart';
import 'package:bcrud/widgets/transparantButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AdDocRejected extends ConsumerStatefulWidget {
  const AdDocRejected({ Key? key }) : super(key: key);

  @override
  _AdDocRejectedState createState() => _AdDocRejectedState();
}

class _AdDocRejectedState extends ConsumerState<AdDocRejected> {
  bool isLoading = false, isSearching = false;
  List<Appuser?>  rejectDoctors = [];

  @override
   void initState() {
    getRejectDoctors();
    super.initState();
  }

  getRejectDoctors() async {
    setState(() => isLoading = true);
    rejectDoctors = await UserController.getRejectedDoctors() ?? [];
    setState(() => isLoading = false);
    print(rejectDoctors.length);
    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(),
      body: isLoading
          ? LinearProgressIndicator()
          : SingleChildScrollView(
            child: 
            Container(
              margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(),
                           defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          children:  [
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
                                    'Specailization',
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
                            for (var i = 0; i < rejectDoctors.length; i++) ...[
                              TableRow(
                                children: [
                                  TableCell(
                                    child: TransparantButton(
                                      onTap: () async {
                                    var user =
                                        await UserController.getUserDetails(
                                            rejectDoctors[i]?.uid ?? '');
                                    if (user == null) return;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProfilePage(
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(rejectDoctors[i]?.name ?? '',
                                      style: const TextStyle(fontSize: 10.0)),
                                ), 
                                  ),
                                   TableCell(
                                child: Center(
                                    child: Text(
                                        rejectDoctors[i]?.email ?? '',
                                        style: TextStyle(fontSize: 10.0))),
                              ),
                              
                              TableCell(
                                child: Center(
                                    child: Text(
                                        rejectDoctors[i]?.phoneNumber ?? '',
                                        style: TextStyle(fontSize: 10.0))),
                              ),
                              TableCell(
                                 child: Center(
                                    child: Text(
                                        rejectDoctors[i]?.specialization ?? '',
                                        style: TextStyle(fontSize: 10.0))),
                                
                              ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        ),
            ),
          )
      
    );
  }
}