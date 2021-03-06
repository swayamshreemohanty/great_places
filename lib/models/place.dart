//@dart=2.9
import 'dart:io'; //This is give us access of methods and types that help to work with files and the file system
import 'package:flutter/foundation.dart';

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });
}

class PlaceLocation {
  final double latitude;
  final double longitude;

  final String address;
  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class UserData {
  // final double id;
  final String displayName;
  final String email;
  final String photoUrl;
  
  const UserData({
    @required this.displayName,
    @required this.email,
    @required this.photoUrl,
  });
}
