import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/check_gmail_pass.dart';
import 'package:login_ui/color.dart';
import 'package:login_ui/image_string.dart';
import 'package:login_ui/string.dart';
import 'package:url_launcher/url_launcher.dart';

class body_01 extends StatefulWidget {
  const body_01({super.key});

  @override
  State<body_01> createState() => _body01State();
}

class _body01State extends State<body_01> {
  FaIcon visibleIcon = FaIcon(FontAwesomeIcons.eyeSlash, size: 20);
  bool visibilityPass = true;
  bool isHover = false;
  Uri forgetUrl = Uri.parse(forget_string);
  Uri createUrl = Uri.parse(create_string);

  Color emailBorderColor = text_field_border_color1;
  Color passwordBorderColor = text_field_border_color1;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Problem with $url";
    }
  }

  void _toggleVisibility() {
    setState(() {
      visibilityPass = !visibilityPass;
      visibleIcon = visibilityPass
          ? FaIcon(FontAwesomeIcons.eyeSlash, size: 20)
          : FaIcon(FontAwesomeIcons.eye, size: 20);
    });
  }

  void _validateInput(String value, bool isEmail) {
    setState(() {
      if (value.isEmpty) {
        emailBorderColor = text_field_border_color1;
        passwordBorderColor = text_field_border_color1;
      } else if (isEmail ? check_gmail(value) : check_password(value)) {
        emailBorderColor = text_field_border_color4;
        passwordBorderColor = text_field_border_color4;
      } else {
        emailBorderColor = text_field_border_color3;
        passwordBorderColor = text_field_border_color3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 350,
        height: mediaQuery.height > 600 ? mediaQuery.height * 0.7 : 400,
        decoration: BoxDecoration(color: container_color),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SvgPicture.asset(logo, height: 70),
              const SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                hintText: user_string,
                isEmail: true,
                onChanged: (value) => _validateInput(value, true),
                errorMessage: errorMessage,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                hintText: pass_string,
                isEmail: false,
                onChanged: (value) => _validateInput(value, false),
                errorMessage: errorMessage,
                suffixIcon: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top:15.0, left: 10.0),
                    child: visibleIcon,
                  ),
                  onTap: _toggleVisibility,
                ),
                obscureText: visibilityPass,
              ),
              const SizedBox(height: 20),
              _buildButton(
                text: login_string,
                onTap: _onLoginTap,
              ),
              const SizedBox(height: 20),
              _buildLinkText(
                text: forget_string,
                onTap: () => _launchUrl(forgetUrl),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildButton(
                text: create_string,
                onTap: () => _launchUrl(createUrl),
                backgroundColor: create_new_account_color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isEmail,
    required Function(String) onChanged,
    String? errorMessage,
    Widget? suffixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isEmail ? emailBorderColor : passwordBorderColor, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isEmail ? emailBorderColor : passwordBorderColor, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: text_field_border_color1),
        errorText: errorMessage,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    Color backgroundColor = const Color(0xff0867fe),
  }) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: body_color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLinkText({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      child: Text(
        text,
        style: TextStyle(
          color: login_color,
          fontSize: 13,
          decoration: isHover ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
      onTap: onTap,
      onHover: (hovering) {
        setState(() {
          isHover = hovering;
        });
      },
    );
  }

  void _onLoginTap() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Empty Credentials";
      });
    } else if (check_gmail(emailController.text) && check_password(passwordController.text)) {
      setState(() {
        errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful", style: TextStyle(color: create_new_account_color))),
      );
    } else {
      setState(() {
        errorMessage = "Invalid Credentials";
      });
    }
  }
}
