import 'package:csv_predictor/handlers/logout_handler.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 17),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        enabled: true,
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(17))),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: const Text(
                      'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 13),
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(17)),
                    child: Text(
                      "Phone Number",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      textAlign: TextAlign.justify,
                    )),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(17)),
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      "Add your Google Account",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    icon: Image.asset(
                      'assets/images/googleLogo.png',
                      scale: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child:
                  SizedBox()), // This will push the "Sign Out" button to the bottom
          Container(
            width: 351,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(92, 172, 170, 170),
              borderRadius: BorderRadius.circular(17),
            ),
            child: TextButton(
              onPressed: () {
                LogoutHandler.logout(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset('assets/images/logout.png', scale: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
