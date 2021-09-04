//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:native_device/providers/google_authentication.dart';
import 'package:native_device/providers/great_places.dart';
import 'package:native_device/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';
import './screens/places_list_screen.dart';
import './screens/add_place_screen.dart';
import './screens/place_details_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
    ),
  );
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
      child: Consumer<Authentication>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Great Places',
          theme: ThemeData(
            primarySwatch: white,
            accentColor: Colors.indigoAccent.shade400,
          ),
          home: RoutePage(),
          routes: {
            SignInScreen.routeName: (ctx) => SignInScreen(),
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
          },
        ),
      ),
    );
  }
}

class RoutePage extends StatefulWidget {
  @override
  RoutePageState createState() => RoutePageState();
}

class RoutePageState extends State<RoutePage> {
  static bool isAuth = false;

  handleSignIn(GoogleSignInAccount account) {
    // ignore: unnecessary_null_comparison
    if (account != null) {
      setState(() {
        isAuth = true;
      });
      // print("User is here: $account");
    } else {
      setState(() {
        isAuth = false;
      });
      // print("User is not here: $account");
    }
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        handleSignIn(account);
        print("Account");
        print(account);
      },
      onError: (error) {
        print('Sign In $error');
      },
    );
    googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        // print("****Sign in Status*****");
        // print(account);
        handleSignIn(account);
      },
    ).catchError(
      (error) {
        print('Error signIn $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth == true ? PlacesList() : SignInScreen();
  }
}
