//@dart=2.9
import 'package:flutter/material.dart';
import 'package:native_device/screens/add_place_screen.dart';
import '../screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../screens/place_details_screen.dart';

class PlacesList extends StatelessWidget {
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
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, dataSnapshot) => dataSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    Provider.of<GreatPlaces>(context, listen: false)
                        .fetchAndSetPlaces(),
                child: Consumer<GreatPlaces>(
                  child: Center(
                    child: const Text('Got no places yet,start adding some'),
                  ),
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (ctx, i) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.items[i].image,
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
    );
  }
}
