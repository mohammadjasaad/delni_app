import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TaxiMapPage extends StatefulWidget {
  const TaxiMapPage({super.key});

  @override
  State<TaxiMapPage> createState() => _TaxiMapPageState();
}

class _TaxiMapPageState extends State<TaxiMapPage> {
  final MapController _mapController = MapController();

  // موقع المستخدم المفترض (مثال)
  final LatLng userLocation = LatLng(33.5138, 36.2765); // دمشق

  // سائقين وهميين
  final List<LatLng> fakeDrivers = [
    LatLng(33.5145, 36.2750),
    LatLng(33.5120, 36.2785),
    LatLng(33.5155, 36.2732),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delni Taxi')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: userLocation,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // موقع المستخدم
              Marker(
                point: userLocation,
                width: 40,
                height: 40,
                child: Icon(Icons.location_pin, size: 40, color: Colors.blue),
              ),
              // سائقين وهميين
              for (final driver in fakeDrivers)
                Marker(
                  point: driver,
                  width: 40,
                  height: 40,
                  child: Icon(Icons.local_taxi, size: 36, color: Colors.amber),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("🚖 تم إرسال طلب تاكسي!")),
          );
        },
        label: Text('طلب تاكسي'),
        icon: Icon(Icons.directions_car),
      ),
    );
  }
}
