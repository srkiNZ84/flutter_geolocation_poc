import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp>{

  Map<String,double> currentLocation = new Map();
  Stream<Map<String,double>> locationSubscription;

  Location location = new Location();
  String error;

  @override
  void initState(){
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubscription = location.onLocationChanged();
    locationSubscription.listen((Map<String,double> result) {
      setState((){
        currentLocation = result;
      });
    });
  }

  void initPlatformState() async {
    Map<String,double> whereAmI;
    try {
      whereAmI = await location.getLocation();
      error = "";
    } on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'GeoLocation permission denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Geolocation permission denied - please ask the user to enable it in the app settings';
      whereAmI = null;
    }
    setState(() {
      currentLocation = whereAmI;
    });
  }

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      home:new Scaffold(
        appBar: AppBar(title: Text('Where Am I?'),),
        body: Center(child:
            Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Latitude: ${currentLocation['latitude']}',
                  style:
                    TextStyle(fontSize: 20.0, color: Colors.blueAccent),),
              Text('Longitude: ${currentLocation['longitude']}',
                  style:
                    TextStyle(fontSize: 20.0, color: Colors.blueAccent),)
            ])
        )
      )
    );
  }
}
