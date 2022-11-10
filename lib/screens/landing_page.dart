import 'package:contact_manager/core/constants/asset_constants.dart';
import 'package:contact_manager/screens/home_page.dart';
import 'package:contact_manager/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.teal[400],
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              SizedBox(
                height: size.height * 0.12,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Contact Manager\nPro",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                      Text(
                        "Stay connected to your contacts!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.10),
              Center(
                child: SvgPicture.asset(
                  homeBackgroundImage,
                  height: size.height * 0.3,
                ),
              ),
              SizedBox(height: size.height * 0.15),
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.06,
                  child: ButtonWidget(
                      title: "Start",
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
