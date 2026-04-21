// lib/component/google_map/google_map.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/services/location/location_service.dart';

class ShowGoogleMap extends StatelessWidget {
  const ShowGoogleMap({
    super.key,
    this.latitude = 0,
    this.longitude = 0,
    this.marker = const [],
    required this.onTapLatLong,
    this.onCurrentLocationResolved,
  });

  final double latitude;
  final double longitude;
  final List<Marker> marker;
  final Function(LatLng value) onTapLatLong;

  /// Called after current-location reverse-geocoding completes.
  /// Provides lat, lng, area name, and details string.
  final Function(double lat, double lng, String area, String details)?
  onCurrentLocationResolved;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowGoogleMapController>(
      init: ShowGoogleMapController(),
      builder: (controller) {
        return GoogleMap(
          initialCameraPosition: (latitude != 0 && longitude != 0)
              ? CameraPosition(
              target: LatLng(latitude, longitude), zoom: 14)
              : controller.kGooglePlex ??
              const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14),
          myLocationEnabled: true,
          onTap: (LatLng latLng) {
            onTapLatLong(latLng);
            controller.setMarker(latLng);
          },
          markers: {
            if (latitude != 0 && longitude != 0)
              Marker(
                markerId: MarkerId(latitude.toInt().toString()),
                position: LatLng(latitude, longitude),
              ),
            ...controller.marker,
          },
          onMapCreated: (GoogleMapController googleMapController) {
            if (!controller.controller.isCompleted) {
              controller.controller.complete(googleMapController);
            }
          },
        );
      },
    );
  }
}

class ShowGoogleMapController extends GetxController {
  List<Marker> marker = [];
  num latitude = 0;
  num longitude = 0;
  Position? positions;

  final Completer<GoogleMapController> controller =
  Completer<GoogleMapController>();
  CameraPosition? kGooglePlex;

  // Callback set from AddAddressScreen
  Function(double lat, double lng, String area, String details)?
  onCurrentLocationResolved;

  Future<Marker> setMarker(LatLng latLng) async {
    marker
      ..clear()
      ..add(Marker(
        markerId: const MarkerId('selected'),
        position: LatLng(latLng.latitude, latLng.longitude),
      ));
    update();
    return marker.first;
  }

  Future<void> getCurrentLocation() async {
    positions = await LocationService.getCurrentPosition();
    if (positions == null) return;

    latitude = positions!.latitude;
    longitude = positions!.longitude;

    kGooglePlex = CameraPosition(
        target: LatLng(positions!.latitude, positions!.longitude), zoom: 15);

    final mar = await setMarker(
        LatLng(positions!.latitude, positions!.longitude));
    marker = [mar];

    final googleMapController = await controller.future;
    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(kGooglePlex!),
    );

    // Reverse geocode to fill address fields
    await _reverseGeocode(positions!.latitude, positions!.longitude);
    update();
  }

  /// Calls Google Reverse Geocoding API and fires onCurrentLocationResolved
  // lib/component/google_map/google_map.dart

  /// Calls Google Reverse Geocoding API and fires onCurrentLocationResolved
  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=$lat,$lng'
          '&key=${ApiEndPoint.googleMapsApiKey}';

      final response = await ApiService.get(url);
      if (response.statusCode != 200) return;

      final status = response.data['status'] as String? ?? '';

      // ── Handle API errors ──────────────────────────────────
      if (status == 'REQUEST_DENIED') {
        /*Get.snackbar(
          "Maps Error",
          "Geocoding API is not enabled. Please enable it in Google Cloud Console.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );*/
        // Still fire callback with coordinates but empty address fields
        onCurrentLocationResolved?.call(lat, lng, '', '');
        return;
      }

      if (status == 'OVER_QUERY_LIMIT') {
        Get.snackbar(
          'Maps Error',
          'API quota exceeded. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        onCurrentLocationResolved?.call(lat, lng, '', '');
        return;
      }

      if (status != 'OK') {
        // ZERO_RESULTS or unknown — just silently pass coordinates
        onCurrentLocationResolved?.call(lat, lng, '', '');
        return;
      }

      // ── Parse successful response ──────────────────────────
      final results = response.data['results'] as List? ?? [];
      if (results.isEmpty) {
        onCurrentLocationResolved?.call(lat, lng, '', '');
        return;
      }

      final components = results.first['address_components'] as List? ?? [];

      String area = '';
      String road = '', sub = '', city = '', country = '';

      for (final c in components) {
        final types = List<String>.from(c['types'] ?? []);
        final name = c['long_name'] ?? '';

        if (types.contains('sublocality_level_1') || types.contains('sublocality')) {
          if (area.isEmpty) area = name;
          sub = name;
        }
        if (types.contains('locality')) {
          if (area.isEmpty) area = name;
          city = name;
        }
        if (types.contains('route')) road = name;
        if (types.contains('country')) country = name;
      }

      final details = [road, sub, city, country]
          .where((e) => e.isNotEmpty)
          .join(', ');

      onCurrentLocationResolved?.call(lat, lng, area, details);

    } catch (e) {
      // Network or parse error — still update coordinates
      onCurrentLocationResolved?.call(lat, lng, '', '');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }
}