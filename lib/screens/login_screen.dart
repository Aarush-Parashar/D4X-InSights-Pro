import 'package:csv_predictor/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv_predictor/screens/upload_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double boxWidth = 300.0;
  final phoneController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  bool isPhoneValid = false;
  bool isOtpSent = false;

  final ButtonStyle blackButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(45),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
  );

  @override
  void dispose() {
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void validatePhone(String value) {
    setState(() {
      isPhoneValid = value.length == 10 && int.tryParse(value) != null;
    });
  }

  void sendOTP() {
    if (isPhoneValid) {
      setState(() {
        isOtpSent = true;
      });
      // TODO: Implement OTP sending logic
    }
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      // TODO: Implement actual OTP verification logic
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      navigateToUpload();
    }
  }

  Future<void> navigateToUpload() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UploadScreen()),
    );
  }

  Future<void> handleSocialLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    navigateToUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SizedBox(
                width: boxWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    const Text('Log in / Sign up',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    _buildPhoneInput(),
                    const SizedBox(height: 20),
                    if (isOtpSent) ...[
                      _buildOTPInput(),
                      const SizedBox(height: 20),
                    ],
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildSocialButtons(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: isPhoneValid ? Colors.green : Colors.black, width: 2),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              const Text('+91', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Enter your phone number',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  onChanged: validatePhone,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isPhoneValid ? sendOTP : null,
          style: blackButtonStyle,
          child: Text(isOtpSent ? 'Resend OTP' : 'Send OTP'),
        ),
      ],
    );
  }

  Widget _buildOTPInput() {
    return Column(
      children: [
        const Text('Enter OTP',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOTPBox(index)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: verifyOTP,
          style: blackButtonStyle,
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 40,
      height: 50,
      child: TextField(
        controller: otpControllers[index],
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          counterText: '',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1)
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('OR',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        ),
        Expanded(child: Divider(color: Colors.black)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        SocialLoginButton(
          icon: 'assets/images/googleLogo.png',
          text: 'Continue with Google',
          onPressed: handleSocialLogin,
        ),
        const SizedBox(height: 10),
        SocialLoginButton(
          icon: 'assets/images/microsoftLogo.png',
          text: 'Continue with Facebook',
          onPressed: handleSocialLogin,
        ),
        const SizedBox(height: 10),
        SocialLoginButton(
          icon: 'assets/images/appleLogo.png',
          text: 'Continue with Apple',
          onPressed: handleSocialLogin,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15.0),
      child: const Text.rich(
        TextSpan(
          text: 'By continuing, you agree to our ',
          children: [
            TextSpan(
              text: 'Terms and Conditions',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
