import 'dart:async';

import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/adminHomePage.dart';
import 'package:bcrud/pages/homePage.dart';
import 'package:bcrud/pages/loginPage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyDPfhFVLq_fbq4td4HtOk2JoHnqYCTX5BM",
      //   appId: "1:98016901312:web:a16a2f938757ba97bf9525",
      //   messagingSenderId: "98016901312",
      //   projectId: "bcrud-8e715",
      //   authDomain: "bcrud-8e715.firebaseapp.com",
      //   storageBucket: "bcrud-8e715.appspot.com",
      //   measurementId: "G-0N0S1NTHG1",
      // ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('firebase err'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const AuthWidget();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class AuthWidget extends ConsumerStatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends ConsumerState<AuthWidget> {
  StreamSubscription<DocumentSnapshot<Appuser>>? usersub;
  setUser(String uid) async {
    await removeUser();
    //ref.read(currentUserProvider.notifier).update(null);
    usersub = UserController.streamUserDocument(uid).listen((event) {
      //ref.refresh(currentUserProvider.state).state =
      ref
          .read(currentUserProvider.notifier)
          .update(event.exists ? event.data() : null);
    });
  }

  Future<void> removeUser() async => await usersub?.cancel();

  @override
  Widget build(BuildContext context) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
      data: (data) {
        //print('auth state changed!! ${data?.email}');
        var d = 'DI7BvRWNdfXZzrbV3mbZA2Db3Wp1';
        if (data == null) {
          //ref.read(currentUserProvider.notifier).update(null);
          //removeUser();
          return const LoginPage();
        } else if (data.uid == d) {
          //njan new edit chetha line
          setUser(data.uid);
          return const AdminHome();
        } else {
          setUser(data.uid);
          return const HomePage();
        }
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text('auth err'),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

//class AuthWidget extends ConsumerWidget {
//  AuthWidget({Key? key}) : super(key: key);
//  StreamSubscription<DocumentSnapshot<Appuser>>? usersub;
//  setUser(String uid, WidgetRef ref) async {
//    //ref.read(currentUserProvider.state).state =
//    //await UserController.getUserDetails(uid);
//    //ref.read(currentUserProvider.state).state =
//    await removeUser();
//    usersub = UserController.streamUserDocument(uid).listen((event) {
//      ref.read(currentUserProvider.state).state =
//          event.exists ? event.data() : null;
//    });
//  }

//  Future<void> removeUser() async => await usersub?.cancel();

//  @override
//  Widget build(BuildContext context, WidgetRef ref) {
//    final _authState = ref.watch(authStateProvider);
//    return _authState.when(
//      data: (data) {
//        if (data == null) {
//          //ref.read(currentUserProvider.state).state = null;
//          //removeUser();
//          return const LoginPage();
//        } else {
//          setUser(data.uid, ref);
//          return const HomePage();
//        }
//      },
//      error: (error, stackTrace) {
//        return const Scaffold(
//          body: Center(
//            child: Text('auth err'),
//          ),
//        );
//      },
//      loading: () => const Scaffold(
//        body: Center(
//          child: CircularProgressIndicator(),
//        ),
//      ),
//    );
//  }
//}
