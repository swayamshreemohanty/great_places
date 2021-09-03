//@dart=2.9

import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyDf0te3EO2rXyXhL-51rqXAT4ARn4O--lY';

class LocationHelper {
  static String generatedLocationPreviewImage(
      {double latitude, double longitude}) {
    var mapWithLocation =
        'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
    return mapWithLocation;
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');
      final response = await http.get(url);

      return json.decode(response.body)['results'][0]['formatted_address'];
    } catch (error) {
      return "Error while fetching your data";
    }
  }
}
