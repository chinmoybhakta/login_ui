import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/string.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'check_gmail_pass.dart';
import 'color.dart';

class body_02 extends StatefulWidget {
  const body_02({super.key});

  @override
  State<body_02> createState() => _body_02State();
}

class _body_02State extends State<body_02> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Artboard? riveArtboard;
  SMITrigger? trigSuccess, trigFail;
  SMIBool? isChecking, isHandsUp;
  SMINumber? numLook;

  FaIcon visibleIcon = const FaIcon(FontAwesomeIcons.eyeSlash, size: 20);
  bool visibilityPass = true;
  bool isHover = false;
  String? errorMessage;

  final Uri urlForget = Uri.parse(forget_url);
  final Uri urlCreate = Uri.parse(create_url);

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  Future<void> _loadRiveFile() async {
    try {
      final data = await rootBundle.load(riveURL);
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(artboard, 'Login Machine');
      if (controller != null) {
        artboard.addController(controller);
        for (var input in controller.inputs) {
          if (input.name == 'isChecking') isChecking = input as SMIBool;
          if (input.name == 'isHandsUp') isHandsUp = input as SMIBool;
          if (input.name == 'trigSuccess') trigSuccess = input as SMITrigger;
          if (input.name == 'trigFail') trigFail = input as SMITrigger;
          if (input.name == 'numLook') numLook = input as SMINumber;
        }
      }
      setState(() => riveArtboard = artboard);
    } catch (e) {
      debugPrint('Error loading Rive file: $e');
    }
  }

  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Cannot launch URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 350,
        height: (mediaQuery.height > 600) ? (mediaQuery.height * 0.7) : 400,
        decoration: BoxDecoration(
          color: container_color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              if (riveArtboard != null)
                SizedBox(
                  height: 200,
                  width: 300,
                  child: Rive(artboard: riveArtboard!,),
                ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                hintText: user_string,
                onChanged: (value) => numLook?.change(value.length.toDouble()),
                onTap: () {
                  isChecking?.change(true);
                  isHandsUp?.change(false);
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 20),
              _buildForgotPasswordLink(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ValueChanged<String> onChanged,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: text_field_border_color1, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: text_field_border_color2, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26),
      ),
      onChanged: onChanged,
      onTap: onTap,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: visibilityPass,
      onChanged: (value) => numLook?.change(value.length.toDouble()),
      onTap: () {
        if(visibilityPass)isHandsUp?.change(true);
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: text_field_border_color1, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: text_field_border_color1, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        hintText: pass_string,
        errorText: errorMessage,
        suffixIcon: IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(() {
              if(visibilityPass) {
                isChecking?.change(true);
                isHandsUp?.change(false);
              }
              else {
                isChecking?.change(false);
                isHandsUp?.change(true);
              }
              visibilityPass = !visibilityPass;
              visibleIcon = visibilityPass
                  ? const FaIcon(FontAwesomeIcons.eyeSlash, size: 20)
                  : const FaIcon(FontAwesomeIcons.eye, size: 20);
            });
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      onTap: () {
        isChecking?.change(false);
        isHandsUp?.change(false);
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          trigFail?.fire();
          setState(() => errorMessage = 'Empty Credentials');
        } else if (check_gmail(emailController.text) &&
            check_password(passwordController.text)) {
          trigSuccess?.fire();
          setState(() => errorMessage = null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful')),
          );
        } else {
          trigFail?.fire();
          setState(() => errorMessage = 'Invalid Credentials');
        }
      },
      child: Container(
        height: 50,
        color: login_color,
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return InkWell(
      onTap: () => _launchUrl(urlForget),
      child: const Text(
        'Forgot Password?',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Text(
          create_string,
          style: TextStyle(fontSize: 18, color: body_color, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(color: create_new_account_color, borderRadius: BorderRadius.circular(5),),
    );
  }
}