import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:location/location.dart';
import 'package:webui/controller/odp_controller.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/models/odp_data.dart';
import 'package:webui/views/directions.dart';
import 'package:webui/views/layout/footer.dart';
import 'package:webui/views/layout/top_bar.dart';

class CekJaringanScreen extends StatefulWidget {
  const CekJaringanScreen({super.key});

  @override
  State<CekJaringanScreen> createState() => _CekJaringanScreenState();
}

class _CekJaringanScreenState extends State<CekJaringanScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  final locationController = Location();
  final Completer<GoogleMapController> _controller = Completer();
  late ODPController odpController;
  LatLng? currentPosition;
  LatLng? userPosition;
  LatLng? nearestODPPosition;
  List<ODP> odpData = [];
  LatLng? selectedODPPosition;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor personIcon;
  bool checkhighway = false;
  bool isRecommended = false;
  List<String> roadRoutesNames = [];
  List<dynamic> odpInRadius = [];
  static const double radarRadius250m = 250;
  List<dynamic> recommendations = [];
  LatLng? lastMarkerPosition;

  @override
  void initState() {
    super.initState();
    _loadPersonIcon();
    odpController = Get.put(ODPController());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      await loadODPData();
      _findNearestODP();
    });
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          if (lastMarkerPosition == null) {
            currentPosition =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            userPosition = currentPosition;
          }
        });
      }
    });
  }

  Future<void> loadODPData() async {
    await odpController.getAllODP();
    setState(() {
      odpData = odpController.semuaODP;
    });
  }

  void _findNearestODP() {
    if (currentPosition == null || odpData.isEmpty) return;

    double closestDistance = double.infinity;
    LatLng closestODP = odpData.first.getLatLng();

    for (var odp in odpData) {
      LatLng odpPosition = odp.getLatLng();
      double distance = calculateDistance(currentPosition!, odpPosition);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestODP = odpPosition;
      }
    }
    setState(() {
      nearestODPPosition = closestODP;
      if (currentPosition != null && nearestODPPosition != null) {
        _getPolyline(currentPosition!, nearestODPPosition!);
      }
    });
    detectDataInRadius();
  }

  void detectDataInRadius() {
    if (currentPosition == null) return;

    // Initialize odpInRadius list
    odpInRadius.clear();

    // Loop through each ODP and add those within the 250m radius
    for (var item in odpData) {
      LatLng position = item.getLatLng();
      double distance = calculateDistance(currentPosition!, position);

      if (distance <= 250) {
        odpInRadius.add({
          'idodp': item.idodp,
          'namaodp': item.namaodp,
          'kategori': item.kategori,
          'latitude': item.latitude,
          'longitude': item.longitude,
          'jarak': distance,
          'checkhighway': checkhighway,
        });
      }
    }

    recommendedProcess(odpInRadius, currentPosition);
  }

  Future<void> recommendedProcess(
      List<dynamic> odpInRadius, LatLng? currentPosition) async {
    // URL backend (replace with your backend URL)
    String backendUrl =
        'https://xj9wv6w0-3000.asse.devtunnels.ms/recommend/processrecommend';

    try {
      // Ensure currentPosition is not null
      if (currentPosition == null) {
        throw Exception('Current position is null');
      }

      // Add currentPosition data to the payload
      Map<String, dynamic> payload = {
        'currentPosition': {
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
        },
        'odpInRadius': odpInRadius,
      };

      // Clear previous recommendations
      recommendations.clear();

      // Send POST request to backend
      http.Response response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Handle response from backend
      if (response.statusCode == 200) {
        // Parse JSON response
        var responseData = jsonDecode(response.body);
        List<dynamic> tempRecommendations =
            List<dynamic>.from(responseData['recommendations']);
        tempRecommendations = tempRecommendations
            .where((item) => item['kategori'] != 'HITAM')
            .map((item) {
          return {
            'idodp': item['idodp'],
            'namaodp': item['nama'],
            'kategori': item['kategori'],
            'jarak': item['jarak'],
            'similarity': item['similarity'],
            'highway': item['highway'],
            'distanceScore': item['distanceScore'],
            'categoryScore': item['categoryScore'],
            'latitude': item['latitude'],
            'longitude': item['longitude']
          };
        }).toList();

        setState(() {
          recommendations = tempRecommendations;
        });

        print(recommendations);
      } else {
        print(
            'Failed to send data. Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending data to backend: $e');
      // Handle error
    }
  }

  void _loadPersonIcon() async {
    try {
      final ByteData byteData =
          await rootBundle.load('assets/images/person.png');
      final Uint8List list = byteData.buffer.asUint8List();

      final resizedImageData = await _resizeImage(list, 50);

      setState(() {
        personIcon = BitmapDescriptor.fromBytes(resizedImageData);
      });
    } catch (e) {
      print('Error loading or resizing person icon: $e');
      // Handle error, e.g., show default icon or retry loading
    }
  }

  Future<Uint8List> _resizeImage(Uint8List data, int size) async {
    try {
      final img.Image? image = img.decodeImage(data);
      if (image == null) return data;

      final img.Image resized =
          img.copyResize(image, width: size, height: size);
      return Uint8List.fromList(img.encodePng(resized));
    } catch (e) {
      print('Error resizing image: $e');
      return data; // Return original data in case of error
    }
  }

  void _updateCameraPosition(LatLng position) async {
    if (_controller.isCompleted) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17));
    }
  }

  Future<void> _getPolyline(LatLng origin, LatLng destination) async {
    if (kIsWeb) {
      setState(() {
        polylineCoordinates = [
          origin,
          destination,
        ];
      });
    } else {
      final directionsLine = DirectionsLine(dio: Dio());
      final directions = await directionsLine.getDirections(
        origin: origin,
        destination: destination,
      );

      bool hasHighway = false;
      List<String> roadNames = directions?.roadNames ?? [];

      // Clean up road names
      List<String> cleanedRoadNames = roadNames.map((roadName) {
        return _cleanUpRoadName(roadName);
      }).toList();

      // Check if any road name matches the highway road names
      for (var roadName in cleanedRoadNames) {
        if (_containsHighwayRoadName(roadName)) {
          hasHighway = true;
          break;
        }
      }

      setState(() {
        polylineCoordinates = directions?.polylinePoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList() ??
            [];
        checkhighway = hasHighway;
        roadRoutesNames = cleanedRoadNames;
      });
    }
  }

  String _cleanUpRoadName(String roadName) {
    // Replace <div> with newlines and remove other HTML tags and entities
    return roadName.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  bool _containsHighwayRoadName(String roadName) {
    // Check if any highway road name matches the given road name
    for (var highwayName in Directions.highwayRoadNames) {
      if (roadName.toLowerCase().contains(highwayName.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void _resetPolyline() {
    setState(() {
      polylineCoordinates.clear();
    });
  }

  void _moveToLocation(LatLng latLng) {
    setState(() {
      currentPosition = latLng;
      _updateCameraPosition(currentPosition!);
      _resetPolyline();
    });
    detectDataInRadius();
  }

  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    String? input = _searchController.text;
    if (input.isNotEmpty) {
      List<String> coordinates = input.split(',');
      if (coordinates.length == 2) {
        double lat = double.tryParse(coordinates[0]) ?? 0.0;
        double lng = double.tryParse(coordinates[1]) ?? 0.0;
        _moveToLocation(LatLng(lat, lng));
        detectDataInRadius();
      } else {
        // Handle invalid input format
        print('Invalid input format. Please enter "lat,lng".');
      }
    }
  }

  void _onODPMarkerTapped(LatLng odpposition) {
    // Cari ODP yang sesuai dengan selectedODPPosition saat ini
    ODP? selectedODP;
    for (var odp in odpData) {
      if (odp.getLatLng() == selectedODPPosition) {
        selectedODP = odp;
        break;
      }
    }

    if (selectedODP != null) {
      isRecommended = recommendations.any((recommendation) =>
          recommendation['namaodp'] == selectedODP?.namaodp);
    } else {
      isRecommended = false;
    }

    if (selectedODPPosition == odpposition) {
      if (selectedODP != null) {
        _showPointDetails(context, selectedODP.namaodp, selectedODP.kategori,
            currentPosition!, selectedODPPosition!, isRecommended);
      }
    } else {
      setState(() {
        selectedODPPosition = odpposition;
      });

      if (currentPosition != null) {
        _getPolyline(currentPosition!, odpposition);
      }
      detectDataInRadius();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb || MediaQuery.of(context).size.width < 600;
    final LatLng defaultPosition = LatLng(0, 0); // Default fallback position

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    'Masukkan koordinat (lat, lng) lokasi usahamu!',
                                hintStyle:
                                    TextStyle(fontSize: isMobile ? 12 : 16)),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        ElevatedButton(
                          onPressed: _handleSearch,
                          style: ElevatedButton.styleFrom(
                            padding: isMobile
                                ? EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15)
                                : EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 24), // Adjust padding
                            textStyle:
                                TextStyle(fontSize: 18), // Increase font size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6), // Adjust border radius if needed
                            ),
                          ),
                          child: Text('Cari',
                              style: TextStyle(fontSize: isMobile ? 12 : 16)),
                        ),
                      ],
                    ),
                  ),
                  // Map and Information
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 10.0),
                    child: isMobile
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: currentPosition ?? defaultPosition,
                                    zoom: 13.0,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                    if (currentPosition != null) {
                                      _moveToLocation(currentPosition!);
                                    }
                                  },
                                  markers: {
                                    if (currentPosition != null)
                                      Marker(
                                        markerId:
                                            const MarkerId('currentLocation'),
                                        icon: personIcon,
                                        position: currentPosition!,
                                        draggable: true,
                                        onDragEnd: (newPosition) {
                                          setState(() {
                                            lastMarkerPosition = newPosition;
                                            currentPosition = newPosition;
                                          });
                                          _moveToLocation(newPosition);
                                        },
                                      ),
                                    for (var odp in odpData)
                                      Marker(
                                        markerId:
                                            MarkerId(odp.idodp.toString()),
                                        icon: BitmapDescriptor.defaultMarker,
                                        position: odp.getLatLng(),
                                        infoWindow: InfoWindow(
                                          title: 'Detail ODP',
                                          snippet:
                                              'Nama ODP: ${odp.namaodp}\nKategori: ${odp.kategori}',
                                        ),
                                        onTap: () {
                                          _getPolyline(
                                              currentPosition ??
                                                  defaultPosition,
                                              odp.getLatLng());
                                        },
                                      ),
                                  },
                                  circles: <Circle>{
                                    if (currentPosition != null)
                                      Circle(
                                        circleId: CircleId('radarZone250m'),
                                        center: currentPosition!,
                                        radius: radarRadius250m,
                                        strokeWidth: 2,
                                        strokeColor:
                                            Colors.blue.withOpacity(0.5),
                                        fillColor: Colors.blue.withOpacity(0.2),
                                      ),
                                  },
                                  polylines: <Polyline>{
                                    if (polylineCoordinates.isNotEmpty)
                                      Polyline(
                                        polylineId: PolylineId('routeToODP'),
                                        points: polylineCoordinates,
                                        color: Colors.green,
                                        width: 5,
                                      ),
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    right: 16.0, left: 5.0, top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: currentPosition == null
                                      ? [
                                          Text(
                                            'Lihat Informasimu disini!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ]
                                      : [
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 30.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (userPosition != null) {
                                                  _moveToLocation(
                                                      userPosition!);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.grey[800],
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Lokasi Saya',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Lihat Informasimu disini!',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 18.0),
                                          Text(
                                              'Titik bisnis kamu berpeluang besar untuk menggunakan jaringan internet Indibiz.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12)),
                                          SizedBox(height: 18.0),
                                          Text(
                                            'Terdapat ${recommendations.length} titik ODP terdekat yang dapat digunakan dari wilayah kamu.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 18.0),
                                          Text(
                                              'Tunggu apalagi, ambil kesempatanmu untuk pakai jaringan internet bisnis Indibiz!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: currentPosition ?? defaultPosition,
                                    zoom: 14.0,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                    if (currentPosition != null) {
                                      _moveToLocation(currentPosition!);
                                    }
                                  },
                                  markers: {
                                    if (currentPosition != null)
                                      Marker(
                                        markerId:
                                            const MarkerId('currentLocation'),
                                        icon: personIcon,
                                        position: currentPosition!,
                                        draggable: true,
                                        onDragEnd: (newPosition) {
                                          setState(() {
                                            lastMarkerPosition = newPosition;
                                            currentPosition = newPosition;
                                          });
                                          _moveToLocation(newPosition);
                                        },
                                      ),
                                    for (var odp in odpData)
                                      Marker(
                                        markerId:
                                            MarkerId(odp.idodp.toString()),
                                        icon: BitmapDescriptor.defaultMarker,
                                        position: odp.getLatLng(),
                                        onTap: () {
                                          _onODPMarkerTapped(odp.getLatLng());
                                        },
                                      ),
                                  },
                                  circles: <Circle>{
                                    if (currentPosition != null)
                                      Circle(
                                        circleId: CircleId('radarZone250m'),
                                        center: currentPosition!,
                                        radius: radarRadius250m,
                                        strokeWidth: 2,
                                        strokeColor:
                                            Colors.blue.withOpacity(0.5),
                                        fillColor: Colors.blue.withOpacity(0.2),
                                      ),
                                  },
                                  polylines: <Polyline>{
                                    if (polylineCoordinates.isNotEmpty)
                                      Polyline(
                                        polylineId: PolylineId('routeToODP'),
                                        points: polylineCoordinates,
                                        color: Colors.green,
                                        width: 5,
                                      ),
                                  },
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.16,
                                padding:
                                    EdgeInsets.only(right: 16.0, left: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: currentPosition == null
                                      ? [
                                          Text(
                                            'Lihat Informasimu disini!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ]
                                      : [
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 30.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (userPosition != null) {
                                                  _moveToLocation(
                                                      userPosition!);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.grey[800],
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Lokasi Saya',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Lihat Informasimu disini!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 18.0),
                                          Text(
                                            'Titik bisnis kamu berpeluang besar untuk menggunakan jaringan internet Indibiz.',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 18.0),
                                          Text(
                                            'Terdapat ${recommendations.length} titik ODP terdekat yang dapat digunakan dari wilayah kamu.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 18.0),
                                          Text(
                                            'Tunggu apalagi, ambil kesempatanmu untuk pakai jaringan internet bisnis Indibiz!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // meters
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _showPointDetails(BuildContext context, String namaodp, String kategori,
      LatLng currentPosition, LatLng odpPosition, bool isRecommended) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (isRecommended)
                  Text(
                    'ODP ini direkomendasikan untuk kamu!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 12),
                Text(
                  'Detail ODP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nama ODP: $namaodp',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Icon(Icons.category, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kategori: $kategori',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Icon(Icons.place, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Jarak: ${calculateDistance(currentPosition, odpPosition).toStringAsFixed(2)} meter',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
