import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/body_03.dart';

import 'body_01.dart';
import 'body_02.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _appBarState();
}

class _appBarState extends State<home_page> {

  int selected_screen = 0;
  List<Widget> screen = [
    body_01(),
    body_02(),
    body_03()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login UI"),
          centerTitle: true,
          leading: Builder(builder: (context)=> IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          }, icon: FaIcon(FontAwesomeIcons.bars))),
          actions: <Widget>[
            IconButton(onPressed: () {

            }, icon: FaIcon(FontAwesomeIcons.bell))
          ],
        ),
        body: SingleChildScrollView(child: screen[selected_screen]),
        //floatingActionButton: ,
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("Simple"),
                onTap: () {
                  setState(() {
                    selected_screen = 0;
                  });
                },
              ),
              ListTile(
                title: Text("Standard"),
                onTap: () {
                  setState(() {
                    selected_screen = 1;
                  });
                },
              ),
              ListTile(
                title: Text("Advance"),
                onTap: () {
                  setState(() {
                    selected_screen = 2;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
