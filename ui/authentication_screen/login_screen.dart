import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'package:foodbuds0_1/ui/authentication_screen/authentication_screen.dart';
import 'package:foodbuds0_1/ui/home_screens/home_screens.dart';
import 'package:foodbuds0_1/models/models.dart' as model;
import 'package:foodbuds0_1/ui/profile_creation/profile_creation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthenticationRepository().signInWithEmailandPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      bool isVerified = await AuthenticationRepository().isEmailVerified();
      if (!isVerified) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MailVerificationPage(),
        ));
        return;
      }

      String? userId = await AuthenticationRepository().getUserId();
      model.User user = await DatabaseRepository().getUser(userId!).first;
      if (user.name == '') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StartCreate(),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Enter your email and password to continue.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 40),
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
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: signInWithEmailAndPassword,
                        child: Text(
                          'LOGIN',
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
            ),
          );
        },
      ),
    );
  }
}
