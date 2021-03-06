//@dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:native_device/models/place.dart';
import 'package:native_device/screens/add_place_screen.dart';
import 'package:native_device/widget/app_drawer.dart';
import '../screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../screens/place_details_screen.dart';

class PlacesList extends StatefulWidget {
  static const routeName = '/places_list';

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  FirebaseAuth _auth;
  UserData _userData;
  User _user;

//This is used to fetch the Current user data for the App Drawer
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  _getCurrentUser() {
    _user = _auth.currentUser;
    _userData = UserData(
      displayName: _user.displayName.toString(),
      email: _user.email.toString(),
      photoUrl: _user.photoURL.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(
        _userData.displayName,
        _userData.email,
        _userData.photoUrl,
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, dataSnapshot) => dataSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                color: Colors.indigo,
                onRefresh: () =>
                    Provider.of<GreatPlaces>(context, listen: false)
                        .fetchAndSetPlaces(),
                child: Consumer<GreatPlaces>(
                  child: Center(
                    child: const Text('Got no places yet,start adding some'),
                  ),
                  builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <=
                          0
                      ? ch
                      : ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (ctx, i) => Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Hero(
                                tag: greatPlaces.items[i].image,
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.items[i].image,
                                  ),
                                ),
                              ),
                              title: Text(greatPlaces.items[i].title),
                              subtitle:
                                  Text(greatPlaces.items[i].location.address),
                              onTap: () {
                                //go to place detail page
                                Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: greatPlaces.items[i].id,
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
