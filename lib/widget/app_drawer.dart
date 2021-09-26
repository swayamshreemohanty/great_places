//@dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:native_device/providers/google_authentication.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer(this.displayName, this.email, this.photoUrl);
  final String displayName;
  final String email;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '$displayName',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              '$email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            currentAccountPicture:
                CircleAvatar(child: Image.network('$photoUrl')),
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
