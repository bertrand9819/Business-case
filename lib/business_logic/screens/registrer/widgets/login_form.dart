import 'package:flutter/material.dart';
import 'package:buniess_case/business_logic/screens/home/homePage.dart';
import 'package:buniess_case/business_logic/screens/registrer/register.dart';

import '../../../constants.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';
import 'fade_slide_transition.dart';

class RegisterForm extends StatefulWidget {
  final Animation<double> animation;
  final double screenHeight;

  const RegisterForm({
    required this.animation,
    required this.screenHeight
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var c = TextEditingController();
  var d = TextEditingController();
  var e = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final space = height > 650 ? kSpaceM : kSpaceS;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        children: <Widget>[
          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: 0.0,
            child:  TextField(
              controller: c,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(kPaddingM),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                hintText: "Email",
                hintStyle: TextStyle(
                  color: kBlack.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: kBlack.withOpacity(0.5),
                ),
              ),
            ),
          ),
          SizedBox(height: space),
          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: 0.0,
            child:  TextField(
              controller: e,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(kPaddingM),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                hintText: "Username",
                hintStyle: TextStyle(
                  color: kBlack.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  Icons.account_box,
                  color: kBlack.withOpacity(0.5),
                ),
              ),
            ),
          ),
          SizedBox(height: space),
          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: space,
            child: TextField(
              controller: d,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(kPaddingM),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                ),
                hintText: "Password",
                hintStyle: TextStyle(
                  color: kBlack.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  Icons.password,
                  color: kBlack.withOpacity(0.5),
                ),
              ),
            ),
          ),

          SizedBox(height: space),
          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: 2 * space,
            child: CustomButton(
              color: kBlue,
              textColor: kWhite,
              text: 'Create Account',
              onPressed: () {
                if(c.text.toString()=="" || d.text.toString() =="" || e.text.toString() ==""  ){

                  ScaffoldMessenger.of(context).showSnackBar(
                    const   SnackBar(
                      content: Text('No Empty field'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const   SnackBar(
                      content: Text('Success'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context) => MyPage()), (
                      Route<dynamic> route) => false);
                }



              },
            ),
          ),

        ],
      ),
    );
  }
}
