import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/utils/response.dart';
import 'package:week7_networking_discussion/utils/validate_email.dart';
import 'package:week7_networking_discussion/screens/components/compound/response_box.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String? emailError;
  String? passwordError;

  setEmailErrorText(String? message) {
    setState(() {
      emailError = message;
    });
  }

  setPasswordErrorText(String? message) {
    setState(() {
      passwordError = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    final email = TextFormField(
      key: const Key("emailField"),
      controller: emailController,
      decoration: InputDecoration(hintText: "Email", errorText: emailError),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your email.";
        }

        if (!validateEmail(email: value)) {
          return "$value is not a valid UP email!";
        }

        return null;
      },
    );

    final password = TextFormField(
      key: const Key("passwordField"),
      controller: passwordController,
      obscureText: true,
      decoration:
          InputDecoration(hintText: 'Password', errorText: passwordError),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your password.";
        }
        return null;
      },
    );

    final firstName = TextFormField(
      key: const Key("firstNameField"),
      controller: firstNameController,
      decoration: const InputDecoration(hintText: 'First Name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your last name.";
        }
        return null;
      },
    );

    final lastName = TextFormField(
      key: const Key("lastNameField"),
      controller: lastNameController,
      decoration: const InputDecoration(hintText: 'Last Name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your last name.";
        }
        return null;
      },
    );

    final signupButton = Padding(
      /// Used for testing purposes.
      key: const Key("signupButton"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Processing data..."),
            ));

            Response response = await context.read<AuthProvider>().signUp(
                email: emailController.text,
                password: passwordController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text);

            if (response is SuccessResponse) {
              // reset all forms
              setState(() {});

              await Future.delayed(const Duration(seconds: 2));

              // ignore: use_build_context_synchronously
              context.read<AuthProvider>().resetResponse();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key("backButton"),
        onPressed: () async {
          Navigator.pop(context);
          //call the auth provider here
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              children: [
                const Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                const HelperInfo(),
                firstName,
                lastName,
                email,
                password,
                signupButton,
                backButton
              ]),
        ),
      ),
    );
  }
}

class LastNameField extends StatelessWidget {
  const LastNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key("lastNameField"),
      decoration: const InputDecoration(hintText: 'Last Name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your last name.";
        }
        return null;
      },
    );
  }
}

class FirstNameField extends StatelessWidget {
  const FirstNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key("firstNameField"),
      decoration: const InputDecoration(hintText: 'First Name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your last name.";
        }
        return null;
      },
    );
    ;
  }
}
