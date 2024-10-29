import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class EspMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String espName;

  EspMap({required this.espName, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(espName),
      ),
      body: FutureBuilder<ByteData>(
        future: rootBundle.load('assets/traffic.png'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final markerIconData = snapshot.data!.buffer.asUint8List();
            final BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerIconData);

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 17.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('${espName}location'),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(title: espName),
                  icon: markerIcon,
                ),
              },
            );
          } else if (snapshot.hasError) {
            // Handle error
            return Text('Error loading marker image');
          } else {
            // Show a placeholder while loading
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}