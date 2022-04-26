import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    this.verificationId,
    required this.isMobile,
  }) : super(key: key);
  final String? verificationId;
  final bool isMobile;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String fireBaseError = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          "We’ve sent you a code",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the confirmation code below',
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (fireBaseError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "*$fireBaseError",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            if (!widget.isMobile)
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Write any OTP ex '123456' ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: true,
              autoFocus: true,
              onChanged: (_) {},
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              showCursor: false,
              pinTheme: PinTheme(
                borderWidth: 1,
                borderRadius: BorderRadius.circular(8.0),
                shape: PinCodeFieldShape.box,
                activeColor: const Color.fromRGBO(236, 236, 236, 1),
                fieldHeight: 69,
                fieldWidth: 47,
                inactiveColor: const Color.fromRGBO(236, 236, 236, 1),
                selectedColor: const Color.fromRGBO(236, 236, 236, 1),
                selectedFillColor: Colors.white,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 100),
              enableActiveFill: true,
              onCompleted: (value) => widget.isMobile
                  ? firebaseOtpValidation(value)
                  : emailOtpValidation(),
              beforeTextPaste: (text) {
                if (text != null) {
                  return int.tryParse(text) == null ? false : true;
                }
                return false;
              },
            ),
            const Text.rich(
              TextSpan(
                  text: "Didn’t recieve a code? ",
                  children: [
                    TextSpan(
                      text: "Wait for 57 sec",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void emailOtpValidation() async {
    await Future.delayed(const Duration(seconds: 1));
    showLoginMessage();
  }

  void showLoginMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully Logged in"),
      ),
    );
    Navigator.of(context).pop();
  }

  void firebaseOtpValidation(String value) async {
    if (fireBaseError.isNotEmpty) {
      setState(() {
        fireBaseError = '';
      });
    }
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!, smsCode: value);
      await FirebaseAuth.instance.signInWithCredential(credential);
      showLoginMessage();
    } on FirebaseAuthException catch (e) {
      setState(() {
        fireBaseError = e.message ?? e.code;
      });
    }
  }
}
