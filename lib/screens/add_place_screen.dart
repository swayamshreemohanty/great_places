//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:native_device/models/place.dart';
import '../widget/image_input.dart';

import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../widget/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  // const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  void _selectPlace(double latitude, double longitude) {
    _pickedLocation = PlaceLocation(latitude: latitude, longitude: longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Add a New Place'),
      ),
      body: Column(
        //This is commented because of the nested Column
        // mainAxisAlignment: MainAxisAlignment
        //     .spaceBetween, //This is used to distribute elements across the screen (here is for column). Here we use to place the button at the end of the screen.
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //use to assign the button size same as the width of the device (for a column is from left to right)
        children: [
          Expanded(
            //Here Expanded use to take the all height/width it can get for the child(here, for the below child). Any element like RaisedButton (Below after the Expanded()),
            //will take the height as it absolutely needs.
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                    10), //To add margin to the element from the device screen edge.
                child: Column(
                  //Here we use nested Column to not equally give space of our Texfield across the screen. We want to keep the TextField on the top of the screen
                  //and keep the AddPlace button at the buttom of the screen.
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      cursorColor: Colors.black,
                      controller: _titleController,
                    ),
                    SizedBox(height: 20),
                    ImageInput(_selectImage),
                    SizedBox(height: 10),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          // Text('User Input'),

          RaisedButton.icon(
            onPressed:
                _savePlace, //Here, the function without (), is used to run that function when the button is pressed, not all the time during the program excecuting.
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              'Add Place',
              style: TextStyle(color: Colors.white),
            ),

            color: Theme.of(context).accentColor,
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize
                .shrinkWrap, //using this we get rid of that extra margin around the button
          ),
        ],
      ),
    );
  }
}
