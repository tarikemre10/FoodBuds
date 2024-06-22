import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/ui/profile_creation/profile_creation.dart';

class MailVerificationPage extends StatefulWidget {
  @override
  _MailVerificationPageState createState() => _MailVerificationPageState();
}

class _MailVerificationPageState extends State<MailVerificationPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sendVerificationEmail(context);
    });
  }

  Future<void> checkEmailVerification(BuildContext context) async {
    bool isVerified = await AuthenticationRepository().isEmailVerified();
    if (isVerified) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StartCreate(),
      ));
    } else {
      await AuthenticationRepository().sendVerificationEmail();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your email is not verified yet. Please check your email.')),
      );
    }
  }

  Future<void> sendVerificationEmail(BuildContext context) async {
    await AuthenticationRepository().sendVerificationEmail();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification email has been sent again. Please check your inbox.')),
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'EMAIL VERIFICATION',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We have sent a verification email to your email address. Please check your email and click on the verification link to verify your account.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await checkEmailVerification(context);
              },
              child: Text(
                'I HAVE VERIFIED MY EMAIL',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await sendVerificationEmail(context);
              },
              child: Text(
                'Resend Verification Email',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
