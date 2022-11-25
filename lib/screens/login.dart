import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';
import 'package:week7_networking_discussion/utils/response.dart';
import 'package:week7_networking_discussion/screens/components/compound/response_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = TextField(
      key: const Key("emailField"),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    final password = TextField(
      key: const Key("passwordField"),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    final loginButton = Padding(
      key: const Key("loginButton"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Processing data..."),
          ));

          Response response = await context
              .read<AuthProvider>()
              .signIn(emailController.text, passwordController.text);

          if (response is SuccessResponse) {
            // ignore: use_build_context_synchronously
            context.read<AuthProvider>().resetResponse();
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key("signUpButton"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const HelperInfo(),
            email,
            password,
            loginButton,
            signUpButton,
          ],
        ),
      ),
    );
  }
}
