//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device/providers/great_places.dart';
import 'package:provider/provider.dart';
import './screens/places_list_screen.dart';
import './screens/add_place_screen.dart';
import './screens/place_details_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesList(),
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          PlaceDetailScreen.routeName:(ctx)=>PlaceDetailScreen(),

        },
      ),
    );
  }
}
