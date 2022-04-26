import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isMobile = false;
  bool _isLoading = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(() {
      final _lastVal = _isMobile;
      _isMobile = _controller.text.trim().startsWith("+");
      if (_lastVal != _isMobile) {
        setState(() {});
        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    });
    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("loading : $_isLoading");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 55,
        titleSpacing: double.minPositive,
        title: const Text(
          "Connect your wallet",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              _isMobile
                  ? "We’ll need this to verify your identity"
                  : 'We’ll send you a confirmation code',
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType:
                  _isMobile ? TextInputType.phone : TextInputType.emailAddress,
              decoration: InputDecoration(
                label: _focusNode.hasFocus || _controller.text.trim().isNotEmpty
                    ? Text(
                        _isMobile ? "Phone" : "Phone number or Email",
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      )
                    : const Text(
                        "Phone number or Email",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                prefixIconConstraints: _isMobile
                    ? const BoxConstraints(maxWidth: 48, maxHeight: 69)
                    : null,
                prefixIcon: _isMobile
                    ? Image.asset(
                        "assets/images/uk.png",
                        width: 48,
                        height: 15,
                      )
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onPressContinue,
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(327, 51),
                primary: const Color.fromRGBO(197, 255, 41, 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text.rich(
              TextSpan(
                text: 'By signing up I agree to Zëdfi’s ',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: ' and ',
                  ),
                  const TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  if (!_isMobile) ...[
                    const TextSpan(
                      text: ' and allow Zedfi to use my email for future ',
                    ),
                    const TextSpan(
                      text: ' Marketing purposes ',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void _onPressContinue() => _isMobile ? mobileAuth() : emailAuth();

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void mobileAuth() async {
    toggleLoading();
    final auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      phoneNumber: _controller.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? e.code),
          ),
        );
        toggleLoading();
      },
      codeSent: (String verificationId, int? resendToken) {
        cleanAndPushToOTPScreen(verificationId: verificationId, isMobile: true);
        toggleLoading();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void emailAuth() => cleanAndPushToOTPScreen(isMobile: false);

  void cleanAndPushToOTPScreen(
      {String? verificationId, required bool isMobile}) {
    _focusNode.unfocus();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (ctx) =>
            OTPScreen(verificationId: verificationId, isMobile: isMobile),
      ),
    )
        .then((_) {
      _controller.clear();
    });
  }
}
