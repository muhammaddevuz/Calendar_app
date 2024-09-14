import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController mapController;
  Point? myCurrentLocation;
  Position? _currentLocation;
  LocationPermission? permission;
  String? _selectedStreet;
  Point? _selectedPoint;

  // ignore: unused_field
  final List<SuggestItem> _suggestionList = [];
  final Point startPoint = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  void _zoomToLocation(Point point) {
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: point,
          zoom: 17,
        ),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 1.5,
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selected Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Tanlangan joy: ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _selectedStreet ?? 'Unknown street',
                      style: const TextStyle(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, {
                    'street': _selectedStreet,
                    'latitude': _selectedPoint?.latitude,
                    'longitude': _selectedPoint?.longitude,
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Select location',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              mapController = controller;
              mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: startPoint,
                    zoom: 17,
                  ),
                ),
              );
            },
            onMapTap: (point) async {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                point.latitude,
                point.longitude,
              );
              if (placemarks.isNotEmpty) {
                setState(() {
                  _selectedStreet = placemarks.first.street;
                  _selectedPoint = point;
                });
                // ignore: use_build_context_synchronously
                _showLocationBottomSheet(context);
              }
            },
            mapType: MapType.vector,
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    mapController.moveCamera(CameraUpdate.zoomIn());
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal.withOpacity(.8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    mapController.moveCamera(CameraUpdate.zoomOut());
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal.withOpacity(.8),
                    ),
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.teal,
        onPressed: () async {
          _currentLocation = await Geolocator.getCurrentPosition(
            // ignore: deprecated_member_use
            desiredAccuracy: LocationAccuracy.high,
          );
          final Point currentPoint = Point(
            latitude: _currentLocation!.latitude,
            longitude: _currentLocation!.longitude,
          );
          _zoomToLocation(currentPoint);
        },
        child: const Icon(CupertinoIcons.location_fill, color: Colors.white),
      ),
    );
  }
}
