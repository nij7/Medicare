import 'package:bcrud/controllers/authController.dart';
import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authControllerProvider = Provider<AuthController>(
    (ref) => AuthController(ref.read(firebaseAuthProvider)));

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authControllerProvider).authStateChange);

//final currentUserProvider = StateProvider<Appuser?>((ref) => null);

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, Appuser?>(
  (ref) => CurrentUserNotifier(),
);

class CurrentUserNotifier extends StateNotifier<Appuser?> {
  CurrentUserNotifier() : super(null);

  //Appuser? get user => state;

  void update(Appuser? newuser) {
    state = newuser;
  }

  void refresh() async {
    state = await UserController.getUserDetails(state?.uid ?? '');
  }
}
