//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device/providers/google_authentication.dart';
import 'package:native_device/providers/great_places.dart';
import 'package:native_device/screens/sign_in_screen.dart';
import 'package:native_device/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import './screens/places_list_screen.dart';
import './screens/add_place_screen.dart';
import './screens/place_details_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GreatPlaces(),
        ),
      ],
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: white,
          accentColor: Colors.indigoAccent.shade400,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, authResultSnapshot) {
              if (authResultSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return SplashScreen();
              }
              if (authResultSnapshot.hasData) {
                return PlacesList();
              }
              return SignInScreen();
            }),
        routes: {
          PlacesList.routeName: (ctx) => PlacesList(),
          SignInScreen.routeName: (ctx) => SignInScreen(),
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
