import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/pages/homePage.dart';
import 'package:bcrud/pages/registrationPage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:bcrud/widgets/appButton.dart';
import 'package:bcrud/widgets/appInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool showError = false;
  String errorText = '';

  login() async {
    try {
      setState(() {
        isLoading = true;
        showError = false;
        errorText = '';
      });
      if (_emailController.text.isEmpty) {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'email cannot be empty';
        });
        return;
      }
      final _auth = ref.read(authControllerProvider);
      final _signFBResult = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (_signFBResult == 'ok') {
        Appuser? _user =
            await UserController.getUserDetails(_auth.currentUser!.uid);
        if (_user != null) {
          ref.read(currentUserProvider.notifier).update(_user);
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
            showError = true;
            errorText = 'Error! user not found';
          });
          return;
        }
      } else if (_signFBResult == 'email-already-in-use') {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'Email already in use';
        });
        return;
      } else {
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'Error!';
        });
        return;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        showError = true;
        errorText = 'Error!';
      });
      return;
    }
  }

  @override
  void setState(VoidCallback fn) => mounted ? super.setState(fn) : {};

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                height: mq * 0.1,
                width: mq * 0.1,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: mqh * 0.1,
                  ),
                  //Container(
                  //  alignment: Alignment.centerLeft,
                  //  width: size.width / 0.5,
                  //  child: IconButton(
                  //      icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
                  //),
                  const Center(
                    child: Text(
                      'MEDICARE',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mqh * 0.25,
                  ),
                  showError
                      ? Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.all(mq * 0.05),
                          padding: EdgeInsets.all(mq * 0.02),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(mq * 0.02),
                              border: Border.all(
                                color: AppColors.errorColor,
                                width: mq * 0.002,
                              )),
                          child: Text(
                            errorText,
                            style: const TextStyle(color: AppColors.errorColor),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: mq * 0.05,
                      bottom: mq * 0.05,
                      left: mq * 0.05,
                    ),
                    child: AppInputField(
                      textEditingController: _emailController,
                      hintText: 'Enter Email',
                      icon: Icons.account_box_rounded,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: mq * 0.05,
                      bottom: mq * 0.05,
                      left: mq * 0.05,
                    ),
                    child: AppInputField(
                        textEditingController: _passwordController,
                        hintText: 'Enter Password',
                        obscureText: true,
                        icon: Icons.lock_rounded),
                  ),

                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 50,
                    ),
                    child: AppButton(
                      onPressed: login,
                    ),
                  ),
                  //SizedBox(height: mq * 0.05),
                  RegisterButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RegistrationPage(),
                    )),
                  )
                  //Container(
                  //  width: size.width,
                  //  alignment: Alignment.center,
                  //  child: field(size, "email", Icons.account_box, _email),
                  //),
                  //Padding(
                  //  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  //  child: Container(
                  //    width: size.width,
                  //    alignment: Alignment.center,
                  //    child: field(size, "password", Icons.lock, _password),
                  //  ),
                  //),
                  //customButton(size),
                  //SizedBox(
                  //  height: size.height / 40,
                  //),
                  //GestureDetector(
                  //  //   onTap: () => Navigator.of(context).push(
                  //  //      MaterialPageRoute(builder: (_)=>  createAccount())),
                  //  child: const Text(
                  //    "Create Account",
                  //    style: TextStyle(
                  //      color: Colors.blue,
                  //      fontSize: 16,
                  //      fontWeight: FontWeight.w500,
                  //    ),
                  //  ),
                  //)
                ],
              ),
            ),
    );
  }

  //Widget customButton(Size size) {
  //  return GestureDetector(
  //    onTap: () {
  //      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
  //        setState(() {
  //          isLoading = true;
  //        });

  //        logIn(_email.text, _password.text).then((user) {
  //          if (user != null) {
  //            print("Login Sucessfull");
  //            setState(() {
  //              isLoading = false;
  //            });
  //            // Navigator.push(
  //            //     context, MaterialPageRoute(builder: (_) => homescreen()));
  //          } else {
  //            print("Login Failed");
  //            setState(() {
  //              isLoading = false;
  //            });
  //          }
  //        });
  //      } else {
  //        print("Please fill form correctly");
  //      }
  //    },
  //    child: Container(
  //        height: size.height / 14,
  //        width: size.width / 1.2,
  //        decoration: BoxDecoration(
  //          borderRadius: BorderRadius.circular(5),
  //          color: Colors.blue,
  //        ),
  //        alignment: Alignment.center,
  //        child: Text(
  //          "Login",
  //          style: TextStyle(
  //            color: Colors.white,
  //            fontSize: 18,
  //            fontWeight: FontWeight.bold,
  //          ),
  //        )),
  //  );
  //}

  //Widget field(
  //    Size size, String hintText, IconData icon, TextEditingController cont) {
  //  return Container(
  //    height: size.height / 14,
  //    width: size.width / 1.1,
  //    child: TextField(
  //      controller: cont,
  //      decoration: InputDecoration(
  //        prefixIcon: Icon(icon),
  //        hintText: hintText,
  //        hintStyle: const TextStyle(color: Colors.grey),
  //        border: OutlineInputBorder(
  //          borderRadius: BorderRadius.circular(10),
  //        ),
  //      ),
  //    ),
  //  );
  //}
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    return MaterialButton(
      onPressed: onPressed,
      height: mq * 0.15,
      minWidth: mq * 0.9,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mq * 0.05)),
      color: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      disabledColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text('REGISTER', style: TextStyle(color: AppColors.primary)),
    );
  }
}
