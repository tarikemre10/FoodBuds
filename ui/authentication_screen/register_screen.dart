import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'package:foodbuds0_1/ui/authentication_screen/verification_screen.dart';
import 'package:foodbuds0_1/models/models.dart' as model;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? errorMessage = " ";

  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password.isEmpty) return false;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    return password.length >= minLength &&
        (hasUppercase || hasLowercase) &&
        hasDigits;
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    if (!isPasswordCompliant(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Password must be at least 8 characters long and include uppercase, lowercase letters, and numbers.")),
      );
      return;
    }

    try {
      await AuthenticationRepository().createUserWithEmailandPassword(
          email: _emailController.text, password: _passwordController.text);
      model.User user = model.User(
        id: AuthenticationRepository().currentUser!.uid,
        name: '',
        surname: '',
        bio: '',
        gender: '',
        genderPreference: '',
        diet: '',
        cuisine: [],
        city: '',
        birthDate: Timestamp.now(),
      );
      DatabaseRepository().createUser(user);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MailVerificationPage(),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'REGISTER NEW ACCOUNT',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: createUserWithEmailAndPassword,
                child: Text(
                  'REGISTER',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}