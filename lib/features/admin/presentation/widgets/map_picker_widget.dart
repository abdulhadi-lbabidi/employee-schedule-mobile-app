import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlong;
class MapPickerWidget extends StatefulWidget {
  final latlong.LatLng? initialLocation;
  final double initialRadius;

  const MapPickerWidget({
    super.key,
    this.initialLocation,
    this.initialRadius = 200,
  });

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  latlong.LatLng? _pickedLocation;
  late double _radius;
  final MapController _mapController = MapController();
  bool _isSatellite = true;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
    _radius = widget.initialRadius;

    if (_pickedLocation == null) {
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final current =
      latlong.LatLng(position.latitude, position.longitude);

      setState(() {
        _pickedLocation = current;
        _mapController.move(current, 15);
      });
    } catch (e) {
      debugPrint("Error determining position: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحديد موقع الورشة"),
        actions: [
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check,
                  color: Colors.green, size: 28),
              onPressed: () {
                Navigator.pop(
                  context,
                  MapPickerResult(
                    location: _pickedLocation!,
                    radius: _radius,
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation ??
                  const latlong.LatLng(33.5138, 36.2765),
              initialZoom: 15,
              onTap: (_, point) {
                setState(() => _pickedLocation = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'com.example.untitled8.nouh_app',
              ),

              if (_pickedLocation != null) ...[
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _pickedLocation!,
                      radius: _radius,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          /// تبديل نوع الخريطة
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              heroTag: 'toggleView',
              onPressed: () =>
                  setState(() => _isSatellite = !_isSatellite),
              backgroundColor: Colors.white,
              child: Icon(
                _isSatellite
                    ? Icons.map
                    : Icons.satellite_alt,
                color: Colors.blue,
              ),
            ),
          ),

          /// شريط اختيار نصف القطر
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "نطاق السماح: ${_radius.toInt()} متر",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _radius,
                      min: 25,
                      max: 500,
                      divisions: 19,
                      label: _radius.round().toString(),
                      onChanged: (val) =>
                          setState(() => _radius = val),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              heroTag: 'myLocation',
              onPressed: _determinePosition,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location,
                  color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPickerResult {
  final latlong.LatLng location;
  final double radius;

  MapPickerResult({
    required this.location,
    required this.radius,
  });
}
