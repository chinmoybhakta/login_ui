
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/string.dart';
import 'check_gmail_pass.dart';
import 'color.dart';
import 'image_string.dart';

class body_03 extends StatefulWidget {
  const body_03({super.key});

  @override
  State<body_03> createState() => _body_03State();
}

class login_position{
   final double x;
   final double y;
   final double z;

   login_position(this.x, this.y, this.z);
}

class _body_03State extends State<body_03> {
  FaIcon visible_icon = FaIcon(FontAwesomeIcons.eyeSlash, size: 20,);
  bool visiblity_pass = true;
  bool is_hover = false;
  Uri url_001 = Uri.parse(forget_url);
  Uri url_002 = Uri.parse(create_url);
  Color check_color_enable = text_field_border_color1;
  Color check_color_focus = text_field_border_color2;
  Color check_color_enable_pass = text_field_border_color1;
  Color check_color_focus_pass = text_field_border_color2;
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  String? errormessage;

  Map<int, login_position> data = {
    1: login_position(200, 0, 220),
    2: login_position(200, 0, 0),
    3: login_position(200, 220, 0),
    4: login_position(0, 220, 0),
    5: login_position(0, 0, 220),
    6: login_position(0, 0, 0)
  };

  int i = 6;

  void change_login_position() {
    setState(() {
      (i == 6) ? i=1 : i++;
      errormessage = "Invalid Credentials";
    });
  }

  void link_underline() {
    setState(() {
      is_hover = !(is_hover);
    });
  }

  void visiblity_button() {
    setState(() {
      visiblity_pass = !(visiblity_pass);
      visible_icon = (visiblity_pass) ? FaIcon(FontAwesomeIcons.eyeSlash, size: 20,) : FaIcon(FontAwesomeIcons.eye, size: 20,);
    });
  }
  @override
  Widget build(BuildContext context) {
    var media_query = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 350,
        height: (media_query.height > 600) ? (media_query.height * 0.7) : 400,
        decoration: BoxDecoration(
          color: container_color,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(child: SvgPicture.asset(logo), height: 70),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: check_color_enable, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: check_color_focus, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  hintText: user_string,
                  hintStyle: TextStyle(color: text_field_border_color1),
                ),
                controller: email_controller,
              ),
              SizedBox(height: 20,),
              TextField(decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: check_color_enable_pass, width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: check_color_focus_pass, width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: pass_string,
                hintStyle: TextStyle(color: Colors.black26),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(child: visible_icon, onTap: () {
                    visiblity_button();
                  }),
                ),
                errorText: errormessage,
              ),
                obscureText: visiblity_pass,
                controller: password_controller,
              ),

              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(top: data[i]!.x, left: data[i]!.y, right: data[i]!.z),
                child: InkWell(
                  child: Container(
                    width: media_query.width*0.2,
                    height: 50,
                    decoration: BoxDecoration(
                      color: login_color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(child: Text(login_string, style: TextStyle(fontSize: 18, color: body_color, fontWeight: FontWeight.bold),)),
                  ),
                  onTap: () {
                    if(!check_gmail(email_controller.text) || !check_password(password_controller.text) || email_controller.text.isEmpty || password_controller.text.isEmpty) {
                      change_login_position();
                    }
                    else {
                      setState(() {
                        errormessage = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login Successful", style: TextStyle(color: create_new_account_color))),
                      );
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}