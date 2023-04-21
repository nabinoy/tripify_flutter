import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:tripify/models/otp_request_model.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class OtpForm extends StatefulWidget {
  static const String routeName = '/otpform';

  const OtpForm({Key? key}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  int _seconds = 60; //600
  late Timer _timer;
  String otp = '';
  bool isTimeOut = false;
  bool isLoading = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_seconds < 1) {
            timer.cancel();
            isTimeOut = true;
          } else {
            _seconds = _seconds - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(int seconds) {
    int minutes = (seconds / 60).truncate();
    int remainingSeconds = seconds - (minutes * 60);
    String formattedSeconds = remainingSeconds < 10
        ? '0$remainingSeconds'
        : remainingSeconds.toString();
    return '$minutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 166, 166, 166)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Verification code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We have sent the verification code to",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.lightBlue[800],
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  otp = pin;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    isLoading = true;
                    HapticFeedback.mediumImpact();
                    VerifyOTPRequest model = VerifyOTPRequest(
                      otp: otp,
                    );
                    APIService.verifyOTP(model).then((response) {
                      if (response['success'].toString() == 'true') {
                        isLoading = false;
                        SharedService.setSharedHomeAfter(true);
                        Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Home.routeName,
                                      (route) => false,
                                    );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            response['message'],
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          backgroundColor: Colors.green,
                        ));
                      }
                    });
                  },
                  color: Colors.lightBlue[800],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: isLoading
                      ? const SizedBox(
                          height: 22.0,
                          width: 22.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              isTimeOut
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          RegenerateOTPRequest model = RegenerateOTPRequest(
                            email: email,
                          );

                          APIService.regenerateOTP(model).then(
                            (response) {
                              // setState(() {
                              //   isApiCallProcess = false;
                              // });
                              if (response
                                  .contains('Successfully Resend OTP')) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    'Successfully sent OTP!',
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  backgroundColor: Colors.green,
                                ));
                                isTimeOut = false;
                                _seconds = 60;
                                startTimer();
                              }
                            },
                          );
                        });
                      },
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                            color: Colors.lightBlue[800],
                            fontWeight: FontWeight.w600),
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Resend code after ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          formatDuration(_seconds),
                          style: TextStyle(
                              color: Colors.lightBlue[800],
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
