import 'package:flutter/material.dart';

import '../../const.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;
    String userToken = "TestToken";
    // todo: login to server
    Navigator.popAndPushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              welcomText(context),
              SizedBox(height: 50),
              emailField(context),
              SizedBox(height: 20),
              passwordField(context),
              SizedBox(height: 45),
              loginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container loginButton(BuildContext context) {
    return Container(
      width: 288,
      height: 65,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7))),
      child: RawMaterialButton(
        onPressed: () {},
        fillColor: Theme.of(context).buttonColor,
        child: Text(
          "login",
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  Container emailField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      height: 60,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: TextFormField(
          controller: emailController,
          style: TextStyle(fontSize: 36),
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              fontSize: 36,
              color: Color.fromRGBO(148, 148, 148, 1),
            ),
          ),
        ),
      ),
    );
  }

  Container passwordField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      height: 60,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: TextFormField(
          controller: passwordController,
          style: TextStyle(fontSize: 36),
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(
              fontSize: 36,
              color: Color.fromRGBO(148, 148, 148, 1),
            ),
          ),
        ),
      ),
    );
  }

  Container welcomText(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: FittedBox(
        child: Text(
          "Login",
          //style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
