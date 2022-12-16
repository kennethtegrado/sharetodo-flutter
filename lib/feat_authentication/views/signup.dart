import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:week7_networking_discussion/config/index.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/utils/response.dart';
import 'package:week7_networking_discussion/utils/validate_email.dart';

// component import
import './components/compound/response_box.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController bdayController = TextEditingController();

    final email = TextFormField(
      key: const Key("emailField"),
      controller: emailController,
      decoration: const InputDecoration(hintText: "Email"),
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
      decoration: const InputDecoration(
          hintText: 'Password',
          helperText:
              "Password must be at least 8 characters long with at least a number, a special character, and both uppercase and lowercase letters.",
          helperMaxLines: 5),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your password.";
        }

        RegExp r = RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$");

        if (!r.hasMatch(value)) {
          return "Invalid password!";
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

    final birthday = TextFormField(
      key: const Key("bdayField"),
      controller: bdayController,
      decoration: const InputDecoration(
          hintText: 'Birthday', helperText: "Format must be in YYYY-MM-DD."),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your birthday.";
        }

        RegExp r = RegExp(r"^[1-2][0-9]{3}\-[0-1][0-9]\-[0-3][0-9]$");

        if (!r.hasMatch(value)) {
          return "Please put a valid birthday!";
        }

        return null;
      },
    );

    final location = TextFormField(
      key: const Key("locationField"),
      controller: locationController,
      decoration: const InputDecoration(hintText: 'Location'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please put your location.";
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
                lastName: lastNameController.text,
                location: locationController.text,
                birthday: DateTime.parse(birthday.controller!.text));

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
                birthday,
                location,
                password,
                signupButton,
                backButton
              ]),
        ),
      ),
    );
  }
}
