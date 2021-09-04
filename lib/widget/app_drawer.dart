//@dart=2.9

import 'package:flutter/material.dart';
import 'package:native_device/providers/google_authentication.dart';
import 'package:native_device/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String user;
  AppDrawer({this.user});
  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<Authentication>(context).user;
    final String user =
        Provider.of<Authentication>(context, listen: false).user;
    print(user);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome $user"),
            automaticallyImplyLeading: false,
            brightness: Brightness.dark,
          ),
          Divider(),
          ListTile(
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushReplacementNamed(SignInScreen.routeName);
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .signOut(context: context);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ));
            },
          )
        ],
      ),
    );
  }
}
