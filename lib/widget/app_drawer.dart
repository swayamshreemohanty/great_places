//@dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:native_device/models/place.dart';
import 'package:native_device/providers/google_authentication.dart';

import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String user;
  AppDrawer({this.user});
  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<Authentication>(context).user;
    final UserData user =
        Provider.of<Authentication>(context, listen: false).userData;

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '${user.displayName}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              //
              '${user.email}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            currentAccountPicture:
                CircleAvatar(child: Image.network('${user.photoUrl}')),
            currentAccountPictureSize: Size(80, 80),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text('Log Out'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Are you sure!"),
                    content: Text("You are about to logout!"),
                    actions: [
                      RaisedButton(
                        elevation: 0,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      RaisedButton(
                        elevation: 0,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigator.of(context)
                          //     .pushReplacementNamed(SignInScreen.routeName);
                          FirebaseAuth.instance.signOut();
                          Provider.of<Authentication>(context, listen: false)
                              .signOut(context: context);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
