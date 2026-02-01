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
  bool _isSatellite = true; // نجعله افتراضياً بنظام القمر الصناعي

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
      setState(() {
        _pickedLocation = latlong.LatLng(position.latitude, position.longitude);
        _mapController.move(_pickedLocation!, 15);
      });
      // طباعة الإحداثيات عند تحديد الموقع الحالي
      debugPrint(" Current Location: Lat: ${position.latitude}, Long: ${position.longitude}");
    } catch (e) {
      debugPrint(" Error determining position: $e");
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
              icon: const Icon(Icons.check, color: Colors.green, size: 30),
              onPressed: () {
                // طباعة الإحداثيات عند الموافقة على الموقع
                debugPrint("✅ Picked Location Confirmed: Lat: ${_pickedLocation!.latitude}, Long: ${_pickedLocation!.longitude}, Radius: $_radius");
                Navigator.pop(context, {
                  'location': _pickedLocation,
                  'radius': _radius,
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation ?? const latlong.LatLng(33.5138, 36.2765),
              initialZoom: 15,
              onTap: (tapPosition, point) {
                setState(() {
                  _pickedLocation = point;
                });
                // طباعة الإحداثيات عند الضغط اليدوي على الخريطة
                debugPrint("📍 Map Tapped: Lat: ${point.latitude}, Long: ${point.longitude}");
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite 
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.untitled8.nouh_app',
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
          
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              heroTag: 'toggleView',
              onPressed: () => setState(() => _isSatellite = !_isSatellite),
              backgroundColor: Colors.white,
              child: Icon(
                _isSatellite ? Icons.map : Icons.satellite_alt,
                color: Colors.blue,
              ),
            ),
          ),
          
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "نطاق السماح: ${_radius.toInt()} متر",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _radius,
                      min: 25,
                      max: 500,
                      divisions: 19,
                      label: _radius.round().toString(),
                      onChanged: (val) {
                        setState(() {
                          _radius = val;
                        });
                      },
                    ),
                    const Text(
                      "اضغط على الخريطة لتحديد مركز الورشة",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
